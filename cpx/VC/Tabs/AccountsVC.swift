//
//  AccountsVC.swift
//  cpx
//
//  Created by Ritesh Sinha on 16/09/24.
//

import UIKit

class AccountsVC: UIViewController {
    
    @IBOutlet weak var progressratiolbl: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var statusLbl: UILabel!
    
    private var selectedLanguage = "English"
    private var accountFields: [AccFieldType] = [.personalDetails, .bankDetails, .support, .delete]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        setProgres()
    }
    
    @IBAction func onClickLogout(_ sender: Any) {
        
        let userId = UserSessionManager.shared.userId ?? ""
        SDKAnalyticsManager.shared.trackEvent(AuthEvent.logout,
                                              params: ["contact_id":userId])
        
        let storyboard = UIStoryboard(name: "Popup", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "LogoutOptionsVC") as? LogoutOptionsVC {
            // Optionally, configure the view controller here
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.navigationController?.present(vc, animated: true)
        }
    }
    
    private func setProgres() {
        let (firstEmptyKey, nonEmptyCount) = UserSessionManager.shared.firstEmptyKeyAndNonEmptyCount()

        if let emptyKey = firstEmptyKey {
            self.statusLbl.text = "Next: \(emptyKey)"
        }
        
        let progressPercentage = Double(nonEmptyCount) / Double(12)
        self.progressView.progress = Float(progressPercentage)
        
        self.progressratiolbl.text = "\(nonEmptyCount)/12"
    }

}

extension AccountsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return accountFields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewProfileTableViewCell", for: indexPath) as! NewProfileTableViewCell
//        cell.configData(index: indexPath.row)
        cell.lblTitle.text = accountFields[indexPath.row].title
        cell.imgLogo.image = UIImage(named: accountFields[indexPath.row].image)
        if (indexPath.row == accountFields.count - 1) {
            cell.cellArrowImg.isHidden = true
            cell.iconView.isHidden = true
            cell.lblTitle.textColor = UIColor.red
        } else {
            cell.cellArrowImg.isHidden = false
            cell.iconView.isHidden = false
            cell.lblTitle.textColor = UIColor(named: "ThemeTextColor")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->
        CGFloat {
            return accountFields[indexPath.row].rowHeight
    }

    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        .zero
    }

    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = .clear
        let userId = UserSessionManager.shared.userId ?? ""
        
        switch accountFields[indexPath.row] {

            
        case .personalDetails:
            
            SDKAnalyticsManager.shared.trackEvent(AppEvent.clickPersonalDetails,
                                                  params: ["contact_id":userId])
            self.tabBarController?.tabBar.isHidden = true
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PersonalDetailsVC") as! PersonalDetailsVC
            self.navigationController?.pushViewController(vc, animated: true)

        case .bankDetails:
            SDKAnalyticsManager.shared.trackEvent(AppEvent.clickBankDetails,
                                                  params: ["contact_id":userId])
            self.tabBarController?.tabBar.isHidden = true
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BankDetailsVC") as! BankDetailsVC
            self.navigationController?.pushViewController(vc, animated: true)
        case .support:
            SDKAnalyticsManager.shared.trackEvent(AppEvent.clickSupportpolicy,
                                                  params: ["contact_id":userId])
            self.tabBarController?.tabBar.isHidden = true
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SupportVC") as! SupportVC
            self.navigationController?.pushViewController(vc, animated: true)
        case .linkaat:
            print("Personal Details")
        case .language:
            
            let storyboard = UIStoryboard(name: "Popup", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "LanguagePopupVC") as? LanguagePopupVC {
                // Optionally, configure the view controller here
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.navigationController?.present(vc, animated: true)
            }
            
        case .refer:
            print("Personal Details")
            
        case .delete:
            SDKAnalyticsManager.shared.trackEvent(AppEvent.deleteAccount,
                                                  params: ["contact_id":userId])
            let storyboard = UIStoryboard(name: "Popup", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "DeleteOptionsVC") as? DeleteOptionsVC {
                // Optionally, configure the view controller here
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.navigationController?.present(vc, animated: true)
            }
            
        case .postRates:
            print("Personal Details")
            
        case.contactUs:
            print("Personal Details")
            
        case .favBrands:
            print("Personal Details")
        }
    }
}
