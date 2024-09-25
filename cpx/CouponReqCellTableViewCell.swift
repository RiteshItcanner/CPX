//
//  CouponReqCellTableViewCell.swift
//  cpx
//
//  Created by Ritesh Sinha on 18/09/24.
//

import UIKit

protocol clickPayoutDelegate: AnyObject {
    func didTapPayout(in cell: CouponReqCellTableViewCell, atIndex: Int)
}

class CouponReqCellTableViewCell: UITableViewCell {

    @IBOutlet weak var payoutBtn: UIButton!
    @IBOutlet weak var uaeReturnPayoutLbl: UILabel!
    @IBOutlet weak var uaeNewPayoutLbl: UILabel!
    @IBOutlet weak var ksaReturnPayoutLbl: UILabel!
    @IBOutlet weak var ksaNewPayoutLbl: UILabel!
    @IBOutlet weak var reqBtn: UIButton!
    @IBOutlet weak var brandLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    weak var delegate: clickPayoutDelegate?
    
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
        ksaNewPayoutLbl.text = "New \(coupon.newSAUPayout)"
        ksaReturnPayoutLbl.text = "Return \(coupon.returningSAUPayout)"
        uaeNewPayoutLbl.text = "New \(coupon.newAREPayout)"
        uaeReturnPayoutLbl.text = "Return \(coupon.returningAREPayout)"
        
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
    }
    
    @IBAction func onClickPayouts(_ sender: UIButton) {
        delegate?.didTapPayout(in: self, atIndex: sender.tag)
    }
    
}
