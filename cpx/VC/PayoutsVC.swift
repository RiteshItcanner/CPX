//
//  PayoutsVC.swift
//  cpx
//
//  Created by Ritesh Sinha on 24/09/24.
//

import UIKit

class PayoutsVC: UIViewController {
    
    @IBOutlet weak var newPayKSALbl: UILabel!
    @IBOutlet weak var returnPayKSALbl: UILabel!
    
    @IBOutlet weak var newPayUAELbl: UILabel!
    @IBOutlet weak var returnPayUAELbl: UILabel!
    
    @IBOutlet weak var newPayBHRLbl: UILabel!
    @IBOutlet weak var returnPayBHRLbl: UILabel!
    
    @IBOutlet weak var newPayEGYLbl: UILabel!
    @IBOutlet weak var returnPayEGYLbl: UILabel!
    
    @IBOutlet weak var newPayKWTLbl: UILabel!
    @IBOutlet weak var returnPayKWTLbl: UILabel!
    
    @IBOutlet weak var newPayOMNLbl: UILabel!
    @IBOutlet weak var returnPayOMNLbl: UILabel!
    
    @IBOutlet weak var newPayQATLbl: UILabel!
    @IBOutlet weak var returnPayQATLbl: UILabel!
    
    @IBOutlet weak var brandLbl: UILabel!
    @IBOutlet weak var brandImg: UIImageView!
    
    var couponInfo: Datum!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 0.8)
        setDetails()
    }
    
    @IBAction func onClickClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onClickRequest(_ sender: UIButton) {
    }
    
    private func setDetails() {
        
        brandLbl.text = couponInfo.brandName
        if let logoUrlString = couponInfo.url, !logoUrlString.isEmpty {
            if let logoUrl = URL(string: logoUrlString) {
                brandImg.kf.setImage(with: logoUrl, placeholder: UIImage(named: "placeholder"))
            } else {
                brandImg.image = UIImage(named: "placeholder")
            }
        } else {
            brandImg.image = UIImage(named: "placeholder")
        }
        
        newPayKSALbl.text = "New \(couponInfo.newSAUPayout)"
        returnPayKSALbl.text = "Return \(couponInfo.returningSAUPayout)"
        
        newPayUAELbl.text = "New \(couponInfo.newAREPayout)"
        returnPayUAELbl.text = "Return \(couponInfo.returningAREPayout)"
        
        newPayBHRLbl.text = "New \(couponInfo.newBHRPayout)"
        returnPayBHRLbl.text = "Return \(couponInfo.returningBHRPayout)"
        
        newPayEGYLbl.text = "New \(couponInfo.newEGYPayout)"
        returnPayEGYLbl.text = "Return \(couponInfo.returningEGYPayout)"
        
        newPayKWTLbl.text = "New \(couponInfo.newKWTPayout)"
        returnPayKWTLbl.text = "Return \(couponInfo.returningKWTPayout)"
        
        newPayOMNLbl.text = "New \(couponInfo.newOMNPayout)"
        returnPayOMNLbl.text = "Return \(couponInfo.returningOMNPayout)"
        
        newPayQATLbl.text = "New \(couponInfo.newQATPayout)"
        returnPayQATLbl.text = "Return \(couponInfo.returningQATPayout)"
        
    }
    
}
