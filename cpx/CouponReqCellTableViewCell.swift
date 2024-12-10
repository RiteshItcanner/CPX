//
//  CouponReqCellTableViewCell.swift
//  cpx
//
//  Created by Ritesh Sinha on 18/09/24.
//

import UIKit
import SVProgressHUD

protocol clickPayoutDelegate: AnyObject {
    func didTapPayout(in cell: CouponReqCellTableViewCell, atIndex: Int)
}

class CouponReqCellTableViewCell: UITableViewCell {

    @IBOutlet weak var payoutBtn: UIButton!
    @IBOutlet weak var globalReturnPayoutValueLbl: UILabel!
    @IBOutlet weak var globalNewPayoutValueLbl: UILabel!
    @IBOutlet weak var reqBtn: UIButton!
    @IBOutlet weak var brandLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    weak var delegate: clickPayoutDelegate?
    var onButtonTap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with coupon: Datum) {
        brandLbl.text = coupon.brandName

        globalNewPayoutValueLbl.text = "New \(coupon.globalNewPayout)"
        globalReturnPayoutValueLbl.text = "Return \(coupon.globalReturningPayout)"
        
        let buttonTitle = coupon.couponStatus == true ? "Requested" : "Request"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Font.AktivGrotsek.medium, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: coupon.couponStatus == true ? UIColor(red: 98/255, green: 117/255, blue: 122/255, alpha: 1) : UIColor.white
        ]
        let attributedTitle = NSAttributedString(string: buttonTitle, attributes: attributes)
        reqBtn.setAttributedTitle(attributedTitle, for: .normal)
        
        reqBtn.isUserInteractionEnabled = coupon.couponStatus == true ? false : true
        
        if coupon.couponStatus == true {
            // If status is "Requested", set background color to rgba(210, 217, 219, 1)
            reqBtn.backgroundColor = UIColor(red: 210/255, green: 217/255, blue: 219/255, alpha: 1)
        } else {
            // Else, keep your default background color (or any other color you want)
            reqBtn.backgroundColor = UIColor(named: "ThemeColor") // Replace with your default color if needed
        }
        
        if let logoUrlString = coupon.url, !logoUrlString.isEmpty {
            if let logoUrl = URL(string: logoUrlString) {
                img.kf.setImage(with: logoUrl, placeholder: UIImage(named: "placeholder"))
            } else {
                img.image = UIImage(named: "placeholder")
            }
        } else {
            img.image = UIImage(named: "placeholder")
        }
        
    }
    
    @IBAction func onClickReq(_ sender: UIButton) {
        let userId = UserSessionManager.shared.userId ?? ""
        SDKAnalyticsManager.shared.trackEvent(CouponEvents.requestCoupon,
                                              params: ["contact_id":userId])
        onButtonTap?()
        
    }
    
    @IBAction func onClickPayouts(_ sender: UIButton) {
        delegate?.didTapPayout(in: self, atIndex: sender.tag)
    }
    
}
