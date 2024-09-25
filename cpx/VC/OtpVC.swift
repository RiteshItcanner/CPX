//
//  OtpVC.swift
//  cpx
//
//  Created by Ritesh Sinha on 17/09/24.
//

import UIKit
import AEOTPTextField
import SVProgressHUD

class OtpVC: UIViewController {

    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var resendCodeBtn: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dintReceiveCodeLbl: UILabel!
    @IBOutlet weak var otpTf: AEOTPTextField!
    
    var timer: Timer?
    var remainingTime: TimeInterval = 120
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        otpTf.otpDelegate = self
        otpTf.configure(with: 4)
        setFont()
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      //  otpTf.becomeFirstResponder()
        resendCodeBtn.isUserInteractionEnabled = false
        descLbl.text = "We sent it to \(self.email) by email."
    }
    
    private func setFont() {
        titleLbl.font = UIFont(name: Font.AktivGrotsekExtended.medium, size: 24)
        descLbl.font = UIFont(name: Font.AktivGrotsek.medium, size: 14)
        dintReceiveCodeLbl.font = UIFont(name: Font.AktivGrotsek.medium, size: 14)
        timeLbl.font = UIFont(name: Font.AktivGrotsek.medium, size: 14)
        resendCodeBtn.titleLabel?.font = UIFont(name: Font.AktivGrotsek.medium, size: 14)
        
    }
    
    func startTimer() {
        // Invalidate the timer if it's already running
        timer?.invalidate()
        
        // Create a timer that fires every second
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimerLabel),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func updateTimerLabel() {
        if remainingTime > 0 {
            // Decrease the remaining time by 1 second
            remainingTime -= 1
            
            // Update the label with the remaining time
            timeLbl.text = timeString(from: remainingTime)
        } else {
            // Time's up, stop the timer
            timer?.invalidate()
            timer = nil
            
            // Call the callback function
            timerFinished()
        }
    }
    
    func timerFinished() {
        resendCodeBtn.isUserInteractionEnabled = true
        resendCodeBtn.titleLabel?.textColor = UIColor.white
        resendCodeBtn.backgroundColor = UIColor(named: "ThemeColor")
    }
    
    func timeString(from time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickResendCode(_ sender: Any) {
        startTimer()
        sendOTPRequest(email: self.email)
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
                self.showAlert(APPLocalizable.app_title, message: response.message)
                // Show success message to the user
            case .failure(let error):
                print("Error: \(error.message)")
                self.showAlert(APPLocalizable.app_title, message: error.message)
                // Show error message to the user
            }
        }
    }
    
    private func showMainTabBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white // Set your desired background color
            
            if #available(iOS 15.0, *) {
                tabBarController.tabBar.scrollEdgeAppearance = appearance
            }
            tabBarController.tabBar.standardAppearance = appearance
            tabBarController.delegate = tabBarController as! any UITabBarControllerDelegate
            print("Number of view controllers: \(tabBarController.viewControllers?.count ?? 0)")
            if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.changeRootViewController(to: tabBarController)
            }
        }
    }
    
    private func verifyOtp(_ otp: String) {
        SVProgressHUD.show()
        APIService.shared.confirmOTP(email: self.email, otp: otp) { result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(let otpResponse):
                print("OTP Confirmed: \(otpResponse.message)")
                
                let userDefaultsManager = UserDefaultsManager()
                userDefaultsManager.save(otpResponse.data, forKey: "UserData")
                let userid = otpResponse.data.id
                SDKAnalyticsManager.shared.trackEvent(AuthEvent.login,
                                                      params: ["contact_id":userid])
                if otpResponse.data.status == "Active" {
                    self.showMainTabBar()
                }
                
                
            case .failure(let otpError):
                print("Error confirming OTP: \(otpError.message)")
                self.showAlert(APPLocalizable.app_title, message: otpError.message)
            }
        }
        
    }
    
}

extension OtpVC: AEOTPTextFieldDelegate {
    func didUserFinishEnter(the code: String) {
        print(code)
        verifyOtp(code)
    }
}
