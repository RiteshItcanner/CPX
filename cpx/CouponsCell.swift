//
//  CouponsCell.swift
//  cpx
//
//  Created by Ritesh Sinha on 17/09/24.
//

import UIKit
import Kingfisher
import SkeletonView

protocol copyBtnDelegate: AnyObject {
    func didTapButton(in cell: CouponsCell, atIndex: Int)
}

class CouponsCell: UITableViewCell {
    
    @IBOutlet weak var codeBtn: UIButton!
    @IBOutlet weak var offerLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    weak var delegate: copyBtnDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        setFonts()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setFonts() {
        self.nameLbl.font = UIFont(name: Font.AktivGrotsek.medium, size: 14)
        self.offerLbl.font = UIFont(name: Font.AktivGrotsek.medium, size: 12)
    }
    
    func showLoading() {
        hideSkeleton(transition: .crossDissolve(0.25))

//        cellBackView.isHidden = false
        let gradient = SkeletonGradient(baseColor: SkeletonAppearance.default.tintColor)
//        shimmerBackView.showAnimatedGradientSkeleton(usingGradient: gradient,
//                                                     transition: .crossDissolve(0.25))
        [img, nameLbl, offerLbl, codeBtn].forEach {
            $0?.showAnimatedSkeleton(usingColor: .white,
                                     animation: .none,
                                     transition: .crossDissolve(0.25))
        }
    }
    
    // Configure the cell with coupon data
    func configure(with coupon: Coupon) {
        offerLbl.text = coupon.couponOffering
        nameLbl.text = coupon.offerName
        codeBtn.setTitle(coupon.coupon, for: .normal)
        
        if let logoUrlString = coupon.offerLogo, !logoUrlString.isEmpty {
            if let logoUrl = URL(string: logoUrlString) {
                img.kf.setImage(with: logoUrl, placeholder: UIImage(named: "placeholder"))
            } else {
                img.image = UIImage(named: "placeholder")
            }
        } else {
            img.image = UIImage(named: "placeholder")
        }
        
    }
    
    @IBAction func onClickCopyCode(_ sender: UIButton) {
        delegate?.didTapButton(in: self, atIndex: sender.tag)
    }
}
