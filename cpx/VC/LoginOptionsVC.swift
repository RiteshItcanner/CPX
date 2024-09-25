//
//  LoginOptionsVC.swift
//  cpx
//
//  Created by Ritesh Sinha on 16/09/24.
//

import UIKit

class LoginOptionsVC: UIViewController {
    
    @IBOutlet weak var appleBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var loginlbl: UILabel!
    
    var completionHandler: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 0.8)
//        setFont()
    }
    
//    private func configLanguage() {
//        loginlbl.text = APPLocalizable.login
//        googleBtn.setTitle(APPLocalizable.continue_google, for: .normal)
//        appleBtn.setTitle(APPLocalizable.continue_apple, for: .normal)
//    }
    
    private func setFont() {
        loginlbl.font = UIFont(name: Font.AktivGrotsek.medium, size: 18)
        googleBtn.titleLabel?.font = UIFont(name: Font.AktivGrotsek.medium, size: 14)
        appleBtn.titleLabel?.font = UIFont(name: Font.AktivGrotsek.medium, size: 14)
        
        googleBtn.layer.borderWidth = 1.0 // Set border width
        googleBtn.layer.borderColor = UIColor(red: 96/255, green: 48/255, blue: 143/255, alpha: 1.0).cgColor 
        googleBtn.layer.cornerRadius = 24 // Set corner radius
        googleBtn.clipsToBounds = true // Ensure the content is clipped to the bounds
        
        appleBtn.layer.borderWidth = 1.0 // Set border width
        appleBtn.layer.borderColor = UIColor(red: 96/255, green: 48/255, blue: 143/255, alpha: 1.0).cgColor
        appleBtn.layer.cornerRadius = 24 // Set corner radius
        appleBtn.clipsToBounds = true // Ensure the content is clipped to the bounds

        
        
        
    }
    
    @IBAction func onClickClose(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func onClickGoogle(_ sender: Any) {
        self.dismiss(animated: false)
        completionHandler?("Google")
    }
    
    @IBAction func onClickApple(_ sender: Any) {
        self.dismiss(animated: false)
        completionHandler?("Apple")
//        SocialLoginHelper.shared.loginWithApple(from: self)
    }
}
