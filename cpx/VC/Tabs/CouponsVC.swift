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
    var duplicateCoupons = [Coupon]()
    var couponReqStatusList = [CouponReqStatusResults]()
    var couponReqList = [Datum]()
    var filteredData = [Datum]()
    var page = 1
    var pageSize = 20
    private var isLoading = false
    private var hasMoreData = true
    private var totalData = 0
    private var searchDebounceTimer: Timer?
    var searchMyCouponsTimer: Timer?
    
    let dispatchGroup = DispatchGroup() // Create a dispatch group to manage the API requests
    
    var myCouponsApiSuccess = false
    var couponReqApiSuccess = false
    var couponReqStatusApiSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureTableAndCollViews()
//        showView1()
        self.showSkeleton()
        
        fetchCoupons(searchStr: nil, shoulReloadTable: false)
        fetchCouponRequest()
        let userId = UserSessionManager.shared.userId ?? ""
        getAllRequestedCouponsAPI(userId)
        
        searchTf.delegate = self
        searchTf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        SVProgressHUD.show()
        dispatchGroup.notify(queue: .main) {
            SVProgressHUD.dismiss() // Dismiss the loader once both API calls are done
            
            if self.myCouponsApiSuccess && self.couponReqApiSuccess && self.couponReqStatusApiSuccess {
                // Both API calls succeeded
//                self.setDetails() // Update the UI after fetching both details
                print("My Coupons and Coupon Req API fetched successfully")
                self.updateCouponStatusByBrandName()
                DispatchQueue.main.async {
                    self.showView1()
                    self.couponsTableView.reloadData()
                    self.couponReqTableView.reloadData()
                    self.hideSkeleton()
                }
            } else {
                // One or both API calls failed
                print("Error fetching My Coupons and Coupon Req API")
            }
        }
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
    
    private func fetchCoupons(searchStr: String?, shoulReloadTable: Bool) {
        let userId = UserSessionManager.shared.userId ?? ""
        let intUserId = Int(userId) ?? 0
        if self.page == 1 {
//            SVProgressHUD.show()
            AppUtility.showLoader()
            self.coupons.removeAll()
        }
        dispatchGroup.enter()
        APIService.shared.getMyCoupons(userId: intUserId, page: self.page, pagesize: self.pageSize, searchStr: searchStr) { result in
            AppUtility.hideLoader()
//            SVProgressHUD.dismiss()
            switch result {
            case .success(let couponResponse):
                print("Coupons fetched successfully: \(couponResponse)")
                self.myCouponsApiSuccess = true
                // Use the couponResponse data as needed
                //                self.coupons = couponResponse.data.coupons
                self.coupons.append(contentsOf: couponResponse.data.coupons)
                
                if searchStr == nil {
                    self.duplicateCoupons = self.coupons
                }
                
                if shoulReloadTable {
                    if self.coupons.count > 0 {
                        self.couponsTableView.reloadData()
                        self.emptyCouponView.isHidden = true
                    } else {
                        self.emptyCouponView.isHidden = false
                    }
                }
                
                let total = couponResponse.data.totals.totalCoupons
                self.totalData = Int(total) ?? 0
                // Handle coupons here (e.g., display in a table view)

                
            case .failure(let otpError):
                self.hideSkeleton()
                print("Error fetching coupons: \(otpError.message)")
                self.showAlert(APPLocalizable.app_title, message: otpError.message)
            }
            self.dispatchGroup.leave()
        }
       
    }
    
    private func fetchCouponRequest() {
        let userId = UserSessionManager.shared.userId ?? ""
        let intUserId = Int(userId) ?? 0
        if self.page == 1 {
//            SVProgressHUD.show()
        }
        dispatchGroup.enter()
        APIService.shared.getCouponRequest(userId: intUserId, page: self.page, pagesize: self.pageSize) { result in
//            SVProgressHUD.dismiss()
            switch result {
            case .success(let couponResponse):
                print("Coupon Requests fetched successfully: \(couponResponse)")
                self.couponReqList.append(contentsOf: couponResponse.data)
                self.filteredData = self.couponReqList
                self.couponReqApiSuccess = true
                // Handle coupons here (e.g., display in a table view)
                
                
            case .failure(let otpError):
                self.hideSkeleton()
                print("Error fetching coupon Requests: \(otpError.message)")
                self.showAlert(APPLocalizable.app_title, message: otpError.message)
            }
            self.dispatchGroup.leave()
        }
    }
    
    @IBAction func onClickSegment(_ sender: UIButton) {
        self.searchTf.text = ""
        couponReqList = filteredData
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
        if self.couponReqList.count > 0 {
            self.emptyCouponView.isHidden = true
            self.emptyCouponReqView.isHidden = true
        } else {
            self.emptyCouponView.isHidden = true
            self.emptyCouponReqView.isHidden = false
        }
    }
    
    private func reqestCouponAPI(_ id: String, subject: String, advertiser: String, date: String, selectedIndexPath: IndexPath) {
        AppUtility.showLoader()
        APIService.shared.requestCoupon(id: id, subject: subject, advertiser: advertiser, date: date) { result in
            AppUtility.hideLoader()
            switch result {
            case .success(let otpResponse):
                print("Coupon status requested: \(otpResponse.message)")
                self.showAlert(APPLocalizable.app_title, message: otpResponse.message)
                
                self.couponReqList[selectedIndexPath.row].couponStatus?.toggle()
                self.filteredData[selectedIndexPath.row].couponStatus?.toggle()
                                    
                // Reload the specific row
                self.couponReqTableView.reloadRows(at: [selectedIndexPath], with: .fade)
                
            case .failure(let otpError):
                print("Error confirming OTP: \(otpError.message)")
                self.showAlert(APPLocalizable.app_title, message: otpError.message)
            }
        }
        
    }
    
    private func getAllRequestedCouponsAPI(_ id: String) {
//        SVProgressHUD.show()
        dispatchGroup.enter()
        APIService.shared.getStatusOfAllCoupons(id: id) { result in
//            SVProgressHUD.dismiss()
            switch result {
            case .success(let response):
                print(response)
                self.couponReqStatusApiSuccess = true
                self.couponReqStatusList.append(contentsOf: response.data.results)
            case .failure(let otpError):
                print("Error confirming OTP: \(otpError.message)")
                self.showAlert(APPLocalizable.app_title, message: otpError.message)
            }
            self.dispatchGroup.leave()
        }
//        dispatchGroup.leave()
        
    }
    
    private func updateCouponStatusByBrandName() {
        // Loop through each item in couponReqList
        for (index, coupon) in couponReqList.enumerated() {
            // Find the corresponding item in couponReqStatusList based on matching brandName
            if let statusResult = couponReqStatusList.first(where: { $0.properties.hsTaskBody == coupon.brandName && $0.properties.hsTaskStatus == "WAITING" }) {
                // If found, update the couponStatus in couponReqList
                couponReqList[index].couponStatus = true
                filteredData[index].couponStatus = true
            } else {
                // If no matching "WAITING" status is found, set the coupon status to false
                couponReqList[index].couponStatus = false
            }
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
        let params = ["contact_id": userId, "coupon_code": info.coupon, "brand_name": info.advertiser]
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
                if coupons.count > indexPath.row {
                    let coupon = coupons[indexPath.row]
                    
                    // Configure the cell with coupon data
                    cell.configure(with: coupon)
                    cell.codeBtn.tag = indexPath.row
                    cell.delegate = self
                }
                
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
                cell.reqBtn.tag = indexPath.row
                cell.delegate = self
                
                cell.onButtonTap = { [weak self] in
                    guard let self = self else { return }
                    // Toggle couponrequest value when button is clicked
//                    self.couponReqList[indexPath.row].couponStatus?.toggle()
//                    self.filteredData[indexPath.row].couponStatus?.toggle()
//                                        
//                    // Reload the specific row
//                    AppUtility.showLoader()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
//                        AppUtility.hideLoader()
//                        self.couponReqTableView.reloadRows(at: [indexPath], with: .fade)
//                    })
                    
                    let userId = UserSessionManager.shared.userId ?? ""
                    guard let dates = getFirstAndLastDateOfCurrentMonth() else {return}
                    let info = self.couponReqList[indexPath.row]
                    let subjStr = "couopnrequest_cpx_" + (info.brandName?.lowercased() ?? "")
                    self.reqestCouponAPI(userId, subject: subjStr, advertiser: info.brandName ?? "", date: dates.todayDate, selectedIndexPath: indexPath)
                }
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
                fetchCoupons(searchStr: self.searchTf.text!, shoulReloadTable: true)
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
        let query = textField.text ?? ""
        let userId = UserSessionManager.shared.userId ?? ""
        if query.isEmpty {
            // If the search field is cleared, reset the data
            resetData()
            
            // Invalidate the search timer to prevent API call
            searchMyCouponsTimer?.invalidate()
            return
        }

        if !self.couponReqTableView.isHidden {
            // Handle debounce for non-empty input for couponReqTableView case
            let params = ["contact_id": userId, "query": query]
            SDKAnalyticsManager.shared.trackEvent(CouponEvents.searchCouponRequest,
                                                  params: params)
            handleSearchInput(query)
        } else {
            // Handle debounce for non-empty input for coupons table
            self.page = 1
            searchMyCouponsTimer?.invalidate()
            
            // Set a new timer with debounce (e.g., 1 second)
            searchMyCouponsTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
                let params = ["contact_id": userId, "query": query]
                SDKAnalyticsManager.shared.trackEvent(CouponEvents.searchCoupons,
                                                      params: params)
                self?.fetchCoupons(searchStr: query, shoulReloadTable: true)
            })
        }
    }

    
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        
//        if !self.couponReqTableView.isHidden {
//            let query = textField.text ?? ""
//            
//            if query.isEmpty {
//                // If search field is cleared, reset data
//                resetData()
//            } else {
//                // Handle debounce for non-empty input
//                handleSearchInput(query)
//            }
//        } else {
//            self.page = 1
//            let query = textField.text ?? ""
//            
//            if query.isEmpty {
//                // If search field is cleared, reset data
//                resetData()
//            } else {
//                // Handle debounce for non-empty input
//                searchMyCouponsTimer?.invalidate()
//                
//                // Set a new timer with debounce (e.g., 0.5 seconds)
//                searchMyCouponsTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
//                    self?.fetchCoupons(searchStr: query)
//                })
//            }
//            
//
//        }
//    }
    
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
            if let brandName = datum.brandName?.lowercased() {
                    return brandName.contains(query.lowercased())
                }
                return false
        }
        
        // Reload table view with the filtered data
        if self.couponReqList.count > 0 {
            couponReqTableView.reloadData()
            self.emptyCouponView.isHidden = true
            self.emptyCouponReqView.isHidden = true
        } else {
            self.emptyCouponView.isHidden = true
            self.emptyCouponReqView.isHidden = false
        }
        
    }
    
    func resetData() {
        // Reset filtered data to the original list when search is cleared
        if !self.couponReqTableView.isHidden {
            couponReqList = filteredData
            couponReqTableView.reloadData() // Refresh table view to show all items
        } else {
            self.page = 1
            self.fetchCoupons(searchStr: nil, shoulReloadTable: true)
//            self.coupons = self.duplicateCoupons
//            couponsTableView.reloadData() // Refresh table view to show all items
//            showView1()
        }
        
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
