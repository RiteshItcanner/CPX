//
//  StatsDetailCell.swift
//  cpx
//
//  Created by Ritesh Sinha on 24/09/24.
//

import UIKit

protocol couponCopyDelegate: AnyObject {
    func didTapButton(in cell: StatsDetailCell, atIndex: Int)
}

class StatsDetailCell: UITableViewCell {

    @IBOutlet weak var btnCopy: UIButton!
    @IBOutlet weak var salesValueLbl: UILabel!
    @IBOutlet weak var payoutValueLbl: UILabel!
    @IBOutlet weak var conversionValueLbl: UILabel!
    @IBOutlet weak var couponCodeLbl: UILabel!
    
    weak var delegate: couponCopyDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with info: DetailsConversion) {
        couponCodeLbl.text = info.couponCode
        conversionValueLbl.text = "\(info.netConversion)"
        payoutValueLbl.text = "\(info.netPayout)"
        salesValueLbl.text = "\(info.saleAmount)"
    }

    @IBAction func onClickCopy(_ sender: UIButton) {
        delegate?.didTapButton(in: self, atIndex: sender.tag)
    }
    
}
