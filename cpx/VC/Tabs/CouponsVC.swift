//
//  CouponsVC.swift
//  cpx
//
//  Created by Ritesh Sinha on 16/09/24.
//

import UIKit
import SVProgressHUD
import SkeletonView
import Toast_Swift

class CouponsVC: UIViewController {
    
    @IBOutlet weak var emptyCouponView: UIView!
    @IBOutlet weak var emptyCouponReqView: UIView!
    @IBOutlet weak var searchTf: UITextField!
    @IBOutlet weak var myCouponsBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var couponReqTableView: UITableView!
    @IBOutlet weak var couponsTableView: UITableView!
    @IBOutlet weak var view1Lbl: UILabel!
    @IBOutlet weak var view2Lbl: UILabel!
    @IBOutlet weak var view2BlueBorder: UIView!
    @IBOutlet weak var view1BlueBorder: UIView!
    
    var coupons = [Coupon]()
    var couponReqList = [Datum]()
    var filteredData = [Datum]()
    var page = 1
    var pageSize = 20
    private var isLoading = false
    private var hasMoreData = true
    private var totalData = 0
    private var searchDebounceTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureTableAndCollViews()
//        showView1()
        self.showSkeleton()
        //        setFonts()
        fetchCoupons()
        fetchCouponRequest()
        
        searchTf.delegate = self
        searchTf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setFonts() {
        self.titleLbl.font = UIFont(name: Font.AktivGrotsek.bold, size: 18)
        self.view1Lbl.font = UIFont(name: Font.AktivGrotsek.medium, size: 12)
        self.view2Lbl.font = UIFont(name: Font.AktivGrotsek.medium, size: 12)
        
    }
    
    func configureTableAndCollViews() {
        couponsTableView.delegate = self
        couponsTableView.dataSource = self
        couponsTableView.isSkeletonable = true
        
        couponReqTableView.delegate = self
        couponReqTableView.dataSource = self
        couponReqTableView.isSkeletonable = true
        
        // Register your custom cell
        couponsTableView.register(UINib(nibName: "CouponsCell", bundle: nil), forCellReuseIdentifier: "CouponsCell")
        couponReqTableView.register(UINib(nibName: "CouponReqCellTableViewCell", bundle: nil), forCellReuseIdentifier: "CouponReqCellTableViewCell")
    }
    
    //    func showSkeleton() {
    //        couponsTableView.showAnimatedSkeleton(transition: .crossDissolve(0.25))
    //    }
    //
    //    func hideSkeleton() {
    //        couponsTableView.hideSkeleton(transition: .crossDissolve(0.25))
    //    }
    
    // MARK: - Skeleton Loading
    func showSkeleton() {
        couponsTableView.showSkeleton(usingColor: .black, transition: .crossDissolve(0.25))
    }
    
    func hideSkeleton() {
        couponsTableView.hideSkeleton(transition: .crossDissolve(0.25))
    }
    
    private func fetchCoupons() {
        let userId = UserSessionManager.shared.userId ?? ""
        let intUserId = Int(userId) ?? 0
        if self.page == 1 {
            SVProgressHUD.show()
        }
        APIService.shared.getMyCoupons(userId: intUserId, page: self.page, pagesize: self.pageSize) { result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(let couponResponse):
                print("Coupons fetched successfully: \(couponResponse)")
                // Use the couponResponse data as needed
                //                self.coupons = couponResponse.data.coupons
                self.coupons.append(contentsOf: couponResponse.data.coupons)
                let total = couponResponse.data.totals.totalCoupons
                self.totalData = Int(total) ?? 0
                // Handle coupons here (e.g., display in a table view)
                DispatchQueue.main.async {
                    self.showView1()
                    self.couponsTableView.reloadData()
                    self.hideSkeleton()
                }
                
            case .failure(let otpError):
                self.hideSkeleton()
                print("Error fetching coupons: \(otpError.message)")
                self.showAlert(APPLocalizable.app_title, message: otpError.message)
            }
        }
    }
    
    private func fetchCouponRequest() {
        let userId = UserSessionManager.shared.userId ?? ""
        let intUserId = Int(userId) ?? 0
        if self.page == 1 {
            SVProgressHUD.show()
        }
        APIService.shared.getCouponRequest(userId: intUserId, page: self.page, pagesize: self.pageSize) { result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(let couponResponse):
                print("Coupon Requests fetched successfully: \(couponResponse)")
                // Use the couponResponse data as needed
                //                self.coupons = couponResponse.data.coupons
                self.couponReqList.append(contentsOf: couponResponse.data)
                self.filteredData = self.couponReqList
                
                // Handle coupons here (e.g., display in a table view)
                DispatchQueue.main.async {
                    self.couponReqTableView.reloadData()
                    self.hideSkeleton()
                }
                
            case .failure(let otpError):
                self.hideSkeleton()
                print("Error fetching coupon Requests: \(otpError.message)")
                self.showAlert(APPLocalizable.app_title, message: otpError.message)
            }
        }
    }
    
    @IBAction func onClickSegment(_ sender: UIButton) {
        if sender.tag == 101 {
            showView1()
        } else {
            showView2()
        }
    }
    
    func showView1() {
        self.view1BlueBorder.isHidden = false
        self.view2BlueBorder.isHidden = true
        self.view1Lbl.textColor = UIColor(named: "ThemeColor")
        self.view2Lbl.textColor = UIColor.lightGray
        self.couponsTableView.isHidden = false
        self.couponReqTableView.isHidden = true
        self.searchTf.text = ""
        if self.coupons.count > 0 {
            self.emptyCouponView.isHidden = true
            self.emptyCouponReqView.isHidden = true
        } else {
            self.emptyCouponView.isHidden = false
            self.emptyCouponReqView.isHidden = true
        }
    }
    
    func showView2() {
        self.view1BlueBorder.isHidden = true
        self.view2BlueBorder.isHidden = false
        self.view2Lbl.textColor = UIColor(named: "ThemeColor")
        self.view1Lbl.textColor = UIColor.lightGray
        self.couponsTableView.isHidden = true
        self.couponReqTableView.isHidden = false
        self.searchTf.text = ""
        if self.couponReqList.count > 0 {
            self.emptyCouponView.isHidden = true
            self.emptyCouponReqView.isHidden = true
        } else {
            self.emptyCouponView.isHidden = true
            self.emptyCouponReqView.isHidden = false
        }
    }
    
}

extension CouponsVC: copyBtnDelegate, clickPayoutDelegate {
    
    func didTapPayout(in cell: CouponReqCellTableViewCell, atIndex: Int) {
        let info = self.couponReqList[atIndex]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PayoutsVC") as! PayoutsVC
        vc.couponInfo = info
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(vc, animated: true)
    }
    
    func didTapButton(in cell: CouponsCell, atIndex: Int) {
        let info = self.coupons[atIndex]
        UIPasteboard.general.string = info.coupon
        AppUtility.showToast(withMessage: "Coupon code copied.")
        
        let userId = UserSessionManager.shared.userId ?? ""
        let params = ["contact_id": userId, "coupon_code": info.coupon]
        SDKAnalyticsManager.shared.trackEvent(CouponEvents.copyCoupons,
                                              params: params)
    }
}

extension CouponsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.couponsTableView {
            return self.coupons.count
        } else {
            return self.couponReqList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.couponsTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CouponsCell", for: indexPath) as? CouponsCell else {
                return UITableViewCell()
            }
            
            
            if !couponsTableView.sk.isSkeletonActive {
                // Get the coupon for this row
                let coupon = coupons[indexPath.row]
                
                // Configure the cell with coupon data
                cell.configure(with: coupon)
                cell.codeBtn.tag = indexPath.row
                cell.delegate = self
            }
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CouponReqCellTableViewCell", for: indexPath) as? CouponReqCellTableViewCell else {
                return UITableViewCell()
            }
            
            
            if !couponsTableView.sk.isSkeletonActive {
                // Get the coupon for this row
                let info = couponReqList[indexPath.row]
                
                // Configure the cell with coupon data
                cell.configure(with: info)
                cell.payoutBtn.tag = indexPath.row
                cell.delegate = self
            }
            //
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == self.couponsTableView {
            let lastElement = coupons.count - 1
            if indexPath.row == lastElement && self.totalData > self.coupons.count {
                // Trigger fetching more data when the last cell is about to be displayed
                self.page += 1
                fetchCoupons()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.couponsTableView {
            return 100
        } else {
            return UITableView.automaticDimension
        }
        
    }
    
}

// MARK: - Search Feature
extension CouponsVC: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if !self.couponReqTableView.isHidden {
            let query = textField.text ?? ""
            
            if query.isEmpty {
                // If search field is cleared, reset data
                resetData()
            } else {
                // Handle debounce for non-empty input
                handleSearchInput(query)
            }
        }
    }
    
    func handleSearchInput(_ searchText: String?) {
        // Invalidate the previous timer to reset the debounce period
        searchDebounceTimer?.invalidate()
        
        // Set a debounce delay of 0.5 seconds before performing the search
        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self, let query = searchText else { return }
            // Perform search only if the query is not empty
            if !query.isEmpty {
                self.performSearch(query: query)
            }
        }
    }
    
    func performSearch(query: String) {
        // Filter data based on the query
        couponReqList = filteredData.filter { datum in
            datum.brandName.lowercased().contains(query.lowercased())
        }
        
        // Reload table view with the filtered data
        couponReqTableView.reloadData()
    }
    
    func resetData() {
        // Reset filtered data to the original list when search is cleared
        couponReqList = filteredData
        couponReqTableView.reloadData() // Refresh table view to show all items
    }
}


// MARK: - Skeleton Table View Delegate
extension CouponsVC: SkeletonTableViewDelegate {
    func collectionSkeletonView(_ skeletonView: UITableView,
                                numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView,
                                cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return CouponsCell.description()
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView,
                                skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        let cell = skeletonView.dequeueCell(ofType: CouponsCell.self)
        cell.showLoading()
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView,
                                prepareCellForSkeleton cell: UITableViewCell,
                                at indexPath: IndexPath) {
        let cell = cell as? CouponsCell
        cell?.showLoading()
    }
}
