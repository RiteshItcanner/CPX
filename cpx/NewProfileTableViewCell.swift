//
//  NewProfileTableViewCell.swift
//  Moon
//
//  Created by Ritesh Sinha on 29/07/24.
//

import UIKit

class NewProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var cellArrowImg: UIImageView!
    @IBOutlet var lblTitle: UILabel! 
    
    @IBOutlet var imgLogo: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        if AppUtility.isRTL {
//            cellArrowImg.image = UIImage(named: "acntArrow_arabic")
//        } else {
//            cellArrowImg.image = UIImage(named: "arrow-right")
//        }
    }
    
//    func configData(index: Int) {
//        lblTitle.textColor = UIColor(red: 15/255,
//                                          green: 0/255,
//                                          blue: 144/255,
//                                          alpha: 1)
//        lblTitle.font = UIFont(name: Font.GraphikArabic.medium, size: 14)
//        lblTitle.font = UIFont(name: Font.AktivGrotsek.medium, size: 14)
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
