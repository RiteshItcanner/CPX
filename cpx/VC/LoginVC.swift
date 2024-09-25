//
//  LoginVC.swift
//  cpx
//
//  Created by Ritesh Sinha on 16/09/24.
//

import UIKit
import JWTDecode
import SVProgressHUD

class LoginVC: UIViewController {

    @IBOutlet weak var otherLoginBtn: UIButton!
    @IBOutlet weak var enterMailLbl: UILabel!
    @IBOutlet weak var orLbl: UILabel!
    @IBOutlet weak var faceDescLbl: UILabel!
    @IBOutlet weak var faceIdLbl: UILabel!
    @IBOutlet weak var codebtn: UIButton!
    @IBOutlet weak var mailTF: UITextField!
    
//    var navigationController: AppNavigationController?
    fileprivate var window: UIWindow!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        setFonts()
    }
    
    override func viewWillLayoutSubviews() {
//        if let font = UIFont(name: Font.AktivGrotsekExtended.bold, size: 24) {
//            self.faceIdLbl.font = font
//        } else {
//            print("Font not found")
//        }
//        setFonts()
    }
    
    private func setFonts() {
//        self.faceIdLbl.font = UIFont(name: Font.AktivGrotsekExtended.bold, size: 24)?.withSize(24)
        self.orLbl.font = UIFont(name: Font.AktivGrotsekExtended.medium, size: 24)
        self.faceIdLbl.font = UIFont(name: Font.AktivGrotsek.medium, size: 14)
        self.enterMailLbl.font = UIFont(name: Font.AktivGrotsek.medium, size: 14)
        codebtn.titleLabel?.font = UIFont(name: Font.AktivGrotsek.medium, size: 14)
    }

    private func setHomeAsRootController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? MainTabBarController {
//            navigationController = nil
//            navigationController = AppNavigationController()
            navigationController?.viewControllers = [vc]
            setupWindow()
        }
    }
    
    func setupWindow() {
        setupAppearance()
//        navigationController?.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func setupAppearance() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func sendOTPRequest(email: String?) {
        guard let email = email, !email.isEmpty else {
            // Show error message if email is empty
            showAlert(APPLocalizable.app_title, message: APPLocalizable.enter_email_msg)
            return
        }
        SVProgressHUD.show()
        APIService.shared.sendOTP(email: email) { result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(let response):
                print("OTP Sent: \(response.message)")
                // Show success message to the user
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtpVC") as! OtpVC
                vc.email = email
                self.navigationController?.pushViewController(vc, animated: true)
            case .failure(let error):
                print("Error: \(error.message)")
                self.showAlert(APPLocalizable.app_title, message: error.message)
                // Show error message to the user
            }
        }
    }
    
    @IBAction func onClickSendcode(_ sender: UIButton) {
        sendOTPRequest(email: mailTF.text)
    }
    
    @IBAction func onClickLoginOther(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginOptionsVC") as! LoginOptionsVC
        vc.completionHandler = { [weak self] data in
            // Handle the data received from ViewControllerB
            print("Data received from VC B: \(data)")
//            self?.mailTF.text = data
            if data == "Apple" {
                SocialLoginHelper.shared.loginWithApple(from: self!)
            } else {
                SocialLoginHelper.shared.GIDSignIn(viewController: self!)
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: false)
    }
    
}

extension LoginVC: SocialLoginHelperDelegate {
    func didSocialLogin(for network: SocialLoginHelper.SocialNetwork,
                        token: String!,
                        identityToken: String!,
                        user: User!) {
        switch network {
        case .google:
//            authenticateWithIMS((user.user_email, user.user_name))
            print(user)
        case .apple:
            do {
                let jwt = try decode(jwt: identityToken)
                guard let email = jwt["email"].string else { return }
//                authenticateWithIMS((email, ""))
                print(email)
                self.mailTF.text = email
                sendOTPRequest(email: email)
                
            } catch let error {
                print(error)
            }

        default:
            break
        }
    }
}
