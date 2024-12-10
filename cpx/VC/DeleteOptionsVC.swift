//
//  DeleteOptionsVC.swift
//  cpx
//
//  Created by Ritesh Sinha on 25/09/24.
//

import UIKit
import SVProgressHUD

class DeleteOptionsVC: UIViewController {

    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var logoutLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 0.8)

    }
    
    @IBAction func onClickClose(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func onClickYes(_ sender: Any) {
        
        let userId = UserSessionManager.shared.userId ?? ""
        SDKAnalyticsManager.shared.trackEvent(AppEvent.deleteAccountSuccess,
                                              params: ["contact_id":userId])
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            SVProgressHUD.dismiss()
            UserSessionManager.shared.clearUserData()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.changeRootViewController(to: vc)
            }
        })

    }
    
    @IBAction func onClickNo(_ sender: Any) {
        self.dismiss(animated: false)
    }

}
