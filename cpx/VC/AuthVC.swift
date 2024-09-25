//
//  AuthVC.swift
//  cpx
//
//  Created by Ritesh Sinha on 16/09/24.
//

import UIKit

class AuthVC: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var brandloginbtn: UIButton!
    @IBOutlet weak var logInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureFonts()
    }
    

    private func configureFonts() {
        titleLbl.font = UIFont(name: Font.AktivGrotsek.medium, size: 16)
        logInBtn.titleLabel?.font = UIFont(name: Font.AktivGrotsek.medium, size: 14)
        brandloginbtn.titleLabel?.font = UIFont(name: Font.AktivGrotsek.medium, size: 14)
    }
    
    
    @IBAction func onClickBrandlogin(_ sender: Any) {
    }
    
    @IBAction func onClickAffiliateLogin(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
