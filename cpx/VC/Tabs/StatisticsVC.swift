//
//  StatisticsVC.swift
//  cpx
//
//  Created by Ritesh Sinha on 16/09/24.
//

import UIKit
//import PageMenu
import DropDown
import SVProgressHUD

class StatisticsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var advValueLbl: UILabel!
    @IBOutlet weak var convValueLbl: UILabel!
    @IBOutlet weak var payoutValueLbl: UILabel!
    @IBOutlet weak var statsCollView: UICollectionView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var statsTableView: UITableView!
    @IBOutlet weak var yearView: UIView!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var mothView: UIView!
    
    //    private var pageMenu : CAPSPageMenu?
    let dropDown = DropDown()
    private var dropdownManager: DropdownManager?
    var page = 1
    var pageSize = 25
    var totalPage = 1
    var clientsArr = [Client]()
    var conversionsArr = [Conversion]()
    private var totalConv = 0
    private var totalPayout = 0.0
    private var totalAdv = 0
    private var monthIndex = 1
    private var advIdArr = [Int]()
    var shouldDeleteClientArr = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropdownManager = DropdownManager(monthAnchorView: mothView, yearAnchorView: yearView)
        
        // Create an instance of UserDefaultsManager
        let userDefaultsManager = UserDefaultsManager()
        
        // Load ConfirmOTPData from UserDefaults
        if let confirmOTPData: ConfirmOTPData = userDefaultsManager.load(ConfirmOTPData.self, forKey: "UserData") {
            // Use the loaded data
            print("User ID: \(confirmOTPData.id)")
            print("User Email: \(confirmOTPData.email)")
            // You can access other properties as needed
        } else {
            print("No data found in UserDefaults")
        }
        
        let monthYearName = getCurrentMonthAndYearName()
        self.monthLbl.text = monthYearName.monthName
        self.yearLbl.text = "\(monthYearName.year)"
        
        statsTableView.delegate = self
        statsTableView.dataSource = self
        
        // Register your custom cell
        statsTableView.register(UINib(nibName: "PerformanceOverviewCell", bundle: nil), forCellReuseIdentifier: "PerformanceOverviewCell")
        
        guard let dates = getFirstAndLastDateOfCurrentMonth() else {return}
        self.monthIndex = dates.monthNumber
        self.fetchStatsData(startDate: dates.firstDate, endDate: dates.lastDate, advId: nil)
        
        //        let nib = UINib(nibName: "PerformanceHeaderView", bundle: nil)
        //        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "PerformanceHeaderView")
    }
    
    @IBAction func onClickMonth(_ sender: UIButton) {
        if sender.tag == 101 {
            dropdownManager?.showMonthDropDown { [weak self] index, selectedMonth in
                self?.page = 1
                self?.advIdArr.removeAll()
                self?.monthLbl.text = selectedMonth
                let yearInt = Int(self?.yearLbl.text ?? "2024")
                self?.monthIndex = index + 1
                if let dates = getFirstAndLastDate(of: index + 1, in: yearInt) {
                    self?.fetchStatsData(startDate: dates.firstDate, endDate: dates.lastDate, advId: nil)
                }
            }
        } else {
            dropdownManager?.showYearDropDown { [weak self] selectedYear in
                self?.page = 1
                self?.advIdArr.removeAll()
                self?.yearLbl.text = selectedYear
                let yearInt = Int(selectedYear)
                if let dates = getFirstAndLastDate(of: self?.monthIndex, in: yearInt) {
                    self?.fetchStatsData(startDate: dates.firstDate, endDate: dates.lastDate, advId: nil)
                }
            }
        }
    }
    
    private func fetchStatsData(startDate: String, endDate: String, advId: [Int]?) {
        let userId = UserSessionManager.shared.userId ?? ""
        let intUserId = Int(userId) ?? 0
        
        if self.page == 1 && self.shouldDeleteClientArr {
            self.clientsArr.removeAll()
        }
        
        if self.page == 1{
//            SVProgressHUD.show()
            AppUtility.showLoader()
            self.conversionsArr.removeAll()
        }
        
        APIService.shared.getStats(userId: intUserId, page: self.page, pagesize: self.pageSize, startDate: startDate, endDate: endDate, advId: advId) { result in
//            SVProgressHUD.dismiss()
            AppUtility.hideLoader()
            switch result {
            case .success(let statsResponse):
                // Handle the successful response
                if self.page == 1 && self.shouldDeleteClientArr {
                    self.clientsArr.append(contentsOf: statsResponse.data.clients)
                }
                self.shouldDeleteClientArr = true
                self.conversionsArr.append(contentsOf: statsResponse.data.conversions)
                self.totalConv = statsResponse.data.totals.totalConversions
                self.totalPayout = statsResponse.data.totals.totalPayout
                self.totalAdv = statsResponse.data.totals.totalAdvertiser
                self.totalPage = statsResponse.data.totals.totalPage
                DispatchQueue.main.async {
                    if self.conversionsArr.count > 0 {
                        
                        self.payoutValueLbl.text = "\(self.totalPayout) AED"
                        self.convValueLbl.text = "\(self.totalConv)"
                        self.advValueLbl.text = "\(self.totalAdv)"
                        
                        self.statsTableView.reloadData()
                        self.statsCollView.reloadData()
                        self.statsTableView.isHidden = false
                        self.statsCollView.isHidden = false
                        self.emptyView.isHidden = true
                    } else {
                        self.payoutValueLbl.text = "0.0 AED"
                        self.convValueLbl.text = "0"
                        self.advValueLbl.text = "0"
                        self.statsTableView.isHidden = true
                        self.statsCollView.isHidden = true
                        self.emptyView.isHidden = false
                    }
                    
                }
            case .failure(let error):
                // Handle the error
                self.payoutValueLbl.text = "0.0 AED"
                self.convValueLbl.text = "0"
                self.advValueLbl.text = "0"
                self.statsTableView.isHidden = true
                self.statsCollView.isHidden = true
                self.emptyView.isHidden = false
                print("Error fetching stats: \(error.localizedDescription)")
            }
        }
    }
    
    // UITableView DataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversionsArr.count // Data array of companies
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PerformanceOverviewCell", for: indexPath) as! PerformanceOverviewCell
        
        // Configure cell with data
        if self.conversionsArr.count > 0 {
            let conv = self.conversionsArr[indexPath.row]
            cell.configure(with: conv)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StatsDetailVC") as! StatsDetailVC
        let userId = UserSessionManager.shared.userId ?? ""
//        let params = ["contact_id": userId, "coupon_code": self.conversionsArr[indexPath.row].det, "brand_name": info.advertiser]
//        SDKAnalyticsManager.shared.trackEvent(CouponEvents.clickStatisticsDetail,params: params)
        
        vc.detailConvArr = self.conversionsArr[indexPath.row].detailsConversion
        vc.advName = self.conversionsArr[indexPath.row].advertiser
        vc.advLogo = self.conversionsArr[indexPath.row].advertiserLogo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.conversionsArr.count - 1
        if indexPath.row == lastElement && self.totalPage > self.page {
            // Trigger fetching more data when the last cell is about to be displayed
            self.page += 1
            print(indexPath.row)
            let yearInt = Int(self.yearLbl.text ?? "2024")
            if let dates = getFirstAndLastDate(of: self.monthIndex, in: yearInt) {
                self.fetchStatsData(startDate: dates.firstDate, endDate: dates.lastDate, advId: nil)
            }
            
        }
    }
    
}

extension StatisticsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.clientsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompanyCollCell", for: indexPath) as! CompanyCollCell
        
        let info = self.clientsArr[indexPath.row]
        if self.advIdArr.contains(Int(info.id) ?? 0) {
            cell.imageRoundView.layer.borderWidth = 4
            cell.imageRoundView.layer.borderColor = UIColor(named: "ThemeTextColor")?.cgColor
        } else {
            cell.imageRoundView.layer.borderWidth = 0.7
            cell.imageRoundView.layer.borderColor = UIColor(red: 103/255, green: 110/255, blue: 118/255, alpha: 1.0).cgColor
        }
        
        if let logoUrlString = info.logo, !logoUrlString.isEmpty {
            if let logoUrl = URL(string: logoUrlString) {
                cell.cellImg.kf.setImage(with: logoUrl, placeholder: UIImage(named: "placeholder"))
            } else {
                cell.cellImg.image = UIImage(named: "placeholder")
            }
        } else {
            cell.cellImg.image = UIImage(named: "placeholder")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.page = 1
        self.shouldDeleteClientArr = false
        let info = self.clientsArr[indexPath.row]
        toggleIdInArray(id: Int(info.id) ?? 0, in: &self.advIdArr)
        let yearInt = Int(self.yearLbl.text ?? "2024")
        
        let userId = UserSessionManager.shared.userId ?? ""
        let params = ["contact_id": userId, "brand_name": info.name]
        SDKAnalyticsManager.shared.trackEvent(CouponEvents.clickStatisticsClient,params: params)
        
        if let dates = getFirstAndLastDate(of: self.monthIndex, in: yearInt) {
            self.fetchStatsData(startDate: dates.firstDate, endDate: dates.lastDate, advId: self.advIdArr)
        }
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set the desired width and height for the collection cell
        let width: CGFloat = 70  // Use CGFloat instead of Int
        let height: CGFloat = 70 // Use CGFloat instead of Int
        return CGSize(width: width, height: height)
    }

    
    func toggleIdInArray(id: Int, in array: inout [Int]) {
        if let index = array.firstIndex(of: id) {
            // If the ID is present, remove it
            array.remove(at: index)
        } else {
            // If the ID is not present, add it
            array.append(id)
        }
    }
    
    
}
