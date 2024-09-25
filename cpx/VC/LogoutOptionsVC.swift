//
//  LogoutOptionsVC.swift
//  cpx
//
//  Created by Ritesh Sinha on 19/09/24.
//

import UIKit

class LogoutOptionsVC: UIViewController {

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
        SDKAnalyticsManager.shared.trackEvent(AuthEvent.logoutSuccess,
                                              params: ["contact_id":userId])
        
        UserSessionManager.shared.clearUserData()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.changeRootViewController(to: vc)
        }
    }
    
    @IBAction func onClickNo(_ sender: Any) {
        self.dismiss(animated: false)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
