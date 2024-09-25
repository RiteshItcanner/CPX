//
//  PerformanceOverviewCell.swift
//  cpx
//
//  Created by Ritesh Sinha on 17/09/24.
//

import UIKit

class PerformanceOverviewCell: UITableViewCell {
    
    @IBOutlet weak var companyLogoImageView: UIImageView!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var conversionsLabel: UILabel!
    @IBOutlet weak var payoutLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var conversionsValueLabel: UILabel!
    @IBOutlet weak var payoutValueLabel: UILabel!
    @IBOutlet weak var revenueValueLabel: UILabel!
    @IBOutlet weak var arrowButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with company: Conversion) {
//        companyLogoImageView.image = UIImage(named: company.advertiserLogo)
        companyNameLabel.text = company.advertiser
        conversionsValueLabel.text = "\(company.totalConversions)"
        payoutValueLabel.text = "\(company.totalPayout)"
        revenueValueLabel.text = "\(company.totalSaleAmount)"
        
        if let logoUrlString = company.advertiserLogo, !logoUrlString.isEmpty {
            if let logoUrl = URL(string: logoUrlString) {
                companyLogoImageView.kf.setImage(with: logoUrl, placeholder: UIImage(named: "placeholder"))
            } else {
                companyLogoImageView.image = UIImage(named: "placeholder")
            }
        } else {
            companyLogoImageView.image = UIImage(named: "placeholder")
        }
    }
    
}
