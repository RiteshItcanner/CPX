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
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var statsTableView: UITableView!
    @IBOutlet weak var yearView: UIView!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var mothView: UIView!
    
    @IBOutlet weak var emptyYearView: UIView!
    @IBOutlet weak var emptyYearLbl: UILabel!
    @IBOutlet weak var emptyMonthLbl: UILabel!
    @IBOutlet weak var emptyMothView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
//    private var pageMenu : CAPSPageMenu?
    let dropDown = DropDown()
    private var dropdownManager: DropdownManager?
    var page = 1
    var pageSize = 20
    var clientsArr = [Client]()
    var conversionsArr = [Conversion]()
    private var totalData = 0
    private var monthIndex = 1
    
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
        
        self.emptyMonthLbl.text = monthYearName.monthName
        self.emptyYearLbl.text = "\(monthYearName.year)"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register your custom cell
        tableView.register(UINib(nibName: "PerformanceOverviewCell", bundle: nil), forCellReuseIdentifier: "PerformanceOverviewCell")
        
        guard let dates = getFirstAndLastDateOfCurrentMonth() else {return}
        self.monthIndex = dates.monthNumber
        self.fetchStatsData(startDate: dates.firstDate, endDate: dates.lastDate)
        
//        let nib = UINib(nibName: "PerformanceHeaderView", bundle: nil)
//        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "PerformanceHeaderView")
    }
    
    @IBAction func onClickMonth(_ sender: UIButton) {
        if sender.tag == 101 {
            dropdownManager?.showMonthDropDown { [weak self] index, selectedMonth in
                self?.monthLbl.text = selectedMonth
                self?.emptyMonthLbl.text = selectedMonth
                let yearInt = Int(self?.yearLbl.text ?? "2024")
                self?.monthIndex = index + 1
                if let dates = getFirstAndLastDate(of: index + 1, in: yearInt) {
                    self?.fetchStatsData(startDate: dates.firstDate, endDate: dates.lastDate)
                }
            }
        } else {
            dropdownManager?.showYearDropDown { [weak self] selectedYear in
                self?.yearLbl.text = selectedYear
                self?.emptyYearLbl.text = selectedYear
                let yearInt = Int(selectedYear)
                if let dates = getFirstAndLastDate(of: self?.monthIndex, in: yearInt) {
                    self?.fetchStatsData(startDate: dates.firstDate, endDate: dates.lastDate)
                }
            }
        }
    }
    
    private func fetchStatsData(startDate: String, endDate: String) {
        let userId = UserSessionManager.shared.userId ?? ""
        let intUserId = Int(userId) ?? 0
            
        if self.page == 1 {
            SVProgressHUD.show()
            self.clientsArr.removeAll()
            self.conversionsArr.removeAll()
        }
        
        APIService.shared.getStats(userId: intUserId, page: self.page, pagesize: self.pageSize, startDate: startDate, endDate: endDate) { result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(let statsResponse):
                // Handle the successful response
                if self.page == 1 {
                    self.clientsArr.append(contentsOf: statsResponse.data.clients)
                }
                self.conversionsArr.append(contentsOf: statsResponse.data.conversions)
                let total = statsResponse.data.totals.totalConversions
                self.totalData = Int(total)
                DispatchQueue.main.async {
                    if self.conversionsArr.count > 0 {
                        self.statsTableView.reloadData()
                        self.statsTableView.isHidden = false
                        self.emptyView.isHidden = true
                    } else {
                        self.statsTableView.isHidden = true
                        self.emptyView.isHidden = false
                    }
                    
                }
            case .failure(let error):
                // Handle the error
                self.statsTableView.isHidden = true
                self.emptyView.isHidden = false
                print("Error fetching stats: \(error.localizedDescription)")
            }
        }
    }
    
    func setupTableHeader() {
        let headerView = Bundle.main.loadNibNamed("PerformanceHeaderView", owner: self, options: nil)?.first as! UIView
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 200) // Adjust height as needed
        tableView.tableHeaderView = headerView
    }
    
    // UITableView DataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversionsArr.count // Data array of companies
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PerformanceOverviewCell", for: indexPath) as! PerformanceOverviewCell
        
        // Configure cell with data
        let conv = self.conversionsArr[indexPath.row]
        cell.configure(with: conv)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StatsDetailVC") as! StatsDetailVC
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
        if indexPath.row == lastElement && self.totalData > self.conversionsArr.count {
            // Trigger fetching more data when the last cell is about to be displayed
            self.page += 1
            guard let dates = getFirstAndLastDateOfCurrentMonth() else {return}
            self.fetchStatsData(startDate: dates.firstDate, endDate: dates.lastDate)
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        // Create and configure your PerformanceHeaderView
//        let nib = UINib(nibName: "PerformanceHeaderView", bundle: nil) // Ensure the nib name matches exactly
//        let views = nib.instantiate(withOwner: nil, options: nil)
//        if let headerView = views.first as? PerformanceHeaderView {
//            headerView.updateData(newData: self.clientsArr) // Pass data to the header view
//            return headerView
//        }
//        return nil
//    }
}

//extension StatisticsVC: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.clientsArr.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompanyCollCell", for: indexPath) as! CompanyCollCell
//        
//        let info = self.clientsArr[indexPath.row]
//        
//        if let logoUrlString = info.logo, !logoUrlString.isEmpty {
//            if let logoUrl = URL(string: logoUrlString) {
//                cell.cellImg.kf.setImage(with: logoUrl, placeholder: UIImage(named: "placeholder"))
//            } else {
//                cell.cellImg.image = UIImage(named: "placeholder")
//            }
//        } else {
//            cell.cellImg.image = UIImage(named: "placeholder")
//        }
//
//        return cell
//    }
//
//
//}
