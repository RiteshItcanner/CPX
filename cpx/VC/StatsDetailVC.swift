//
//  StatsDetailVC.swift
//  cpx
//
//  Created by Ritesh Sinha on 23/09/24.
//

import UIKit

class StatsDetailVC: UIViewController, couponCopyDelegate {
    
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var brandImg: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    
    var detailConvArr = [DetailsConversion]()
    var advName = ""
    var advLogo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.brandName.text = advName
        if let logoUrlString = advLogo, !logoUrlString.isEmpty {
            if let logoUrl = URL(string: logoUrlString) {
                self.brandImg.kf.setImage(with: logoUrl, placeholder: UIImage(named: "placeholder"))
            } else {
                self.brandImg.image = UIImage(named: "placeholder")
            }
        } else {
            self.brandImg.image = UIImage(named: "placeholder")
        }
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didTapButton(in cell: StatsDetailCell, atIndex: Int) {
        let info = self.detailConvArr[atIndex]
        UIPasteboard.general.string = info.couponCode
        AppUtility.showToast(withMessage: "Coupon code copied.")
        
        let userId = UserSessionManager.shared.userId ?? ""
        let params = ["contact_id": userId, "coupon_code": info.couponCode]
        SDKAnalyticsManager.shared.trackEvent(CouponEvents.copyCoupons,
                                              params: params)
    }
    
}

extension StatsDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailConvArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatsDetailCell", for: indexPath) as! StatsDetailCell
        let info = self.detailConvArr[indexPath.row]
        cell.configure(with: info)
        cell.btnCopy.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}
