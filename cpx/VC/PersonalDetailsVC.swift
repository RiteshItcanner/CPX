//
//  PersonalDetailsVC.swift
//  cpx
//
//  Created by Ritesh Sinha on 18/09/24.
//

import UIKit
import SVProgressHUD

class PersonalDetailsVC: UIViewController {
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var titleStr: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var birthdayLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var phoneNoTf: UITextField!
    @IBOutlet weak var birthdayTf: UITextField!
    @IBOutlet weak var addressTf: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configAlignments()
        configLanguage()
        setemailvalidation()
        nameTf.delegate = self
        setDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setemailvalidation()
    }
    
    private func fetchUserDetails() {
        let userId = UserSessionManager.shared.userId ?? ""
        let intUserId = Int(userId) ?? 0
        SVProgressHUD.show()
        APIService.shared.getUserDetails(userId: intUserId) { result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(let couponResponse):
                print("User details successfully: \(couponResponse)")
                let email = couponResponse.data.email ?? ""
                let phone = couponResponse.data.phone ?? ""
                let address = couponResponse.data.address1 ?? ""
                let name = ""
                let birthday = ""
                UserSessionManager.shared.saveUserDetails(email: email, name: name, phone: phone, birthday: birthday, address: address)
                self.setDetails()

            case .failure(let otpError):
                print("Error fetching User details: \(otpError.message)")
                self.showAlert(APPLocalizable.app_title, message: otpError.message)
            }
        }
    }
    
    private func setDetails() {
        let userDetails = UserSessionManager.shared.getUserDetails()
        self.emailTf.text = userDetails.email
        self.phoneNoTf.text = userDetails.phone
        self.nameTf.text = userDetails.name
        self.birthdayTf.text = userDetails.birthday
        self.addressTf.text = userDetails.address
    }
    
    private func setemailvalidation() {
        self.emailTf.isUserInteractionEnabled = emailTf.text!.isEmpty
    }

    
    private func configLanguage() {
        btnSave.setTitle(APPLocalizable.edit_request, for: .normal)
        btnDelete.setTitle(APPLocalizable.delete_acc, for: .normal)
        emailLbl.text = APPLocalizable.email
        phoneLbl.text = APPLocalizable.phone_number
        addressLbl.text = APPLocalizable.address
        birthdayLbl.text = APPLocalizable.birthday
        nameLbl.text = APPLocalizable.name
        titleStr.text = APPLocalizable.personal_details
//        if AppUtility.isRTL {
//            btnBack.setImage(UIImage(named: "icn_back_arabic"), for: .normal)
//        } else {
//            btnBack.setImage(UIImage(named: "icn_back"), for: .normal)
//        }
    }
    
    @IBAction func birthdayTapped(_ sender: UIButton) {
        showDatePicker()
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
//        updateUserDetailToHubSpot()
    }
    
    
    
    func showDatePicker() {
        let datePicker = UIDatePicker()
        let alertController = UIAlertController(title: "" /* "\n\n\n\n\n\n\n\n\n" */, message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        datePicker.frame = CGRect(x: 0, y: 0, width: alertController.view.frame.width - 20, height: 225)
        datePicker.subviews.forEach { subview in
            if subview.frame.size.width < 150 {
                subview.frame.size.width = 150
            }
        }
        
        // Add date picker to alert controller
        alertController.view.addSubview(datePicker)
        
        // Create done button
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.birthdayTf.text = dateFormatter.string(from: datePicker.date)
            // Save selected date here if needed
        }
        
        alertController.addAction(doneAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
//        if let thisController = UIStoryboard(storyboard: UIStoryboard.Storyboard.popup).instantiateViewController(withIdentifier: "SaveChangesPopupVC") as? SaveChangesPopupVC {
//            thisController.modalPresentationStyle = .overFullScreen
//            navigationController?.present(thisController, animated: true)
//            thisController.blockConfirm = {
//                self.updateUserDetailToHubSpot()
//            }
//            thisController.blockCancel = {
//                self.navigationController?.popToRootViewController(animated: true)
//
//                
//            }
//        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickDelete(_ sender: Any) {
//        if let thisController = UIStoryboard(storyboard: UIStoryboard.Storyboard.popup).instantiateViewController(withIdentifier: "DeleteAccountPopupVC") as? DeleteAccountPopupVC {
//            thisController.modalPresentationStyle = .overFullScreen
//            navigationController?.present(thisController, animated: true)
//            thisController.blockConfirm = {
//                SDKAnalyticsManager.shared.trackEvent(event: AuthEvent.deleteAcc)
//                // Need to call delete account API and then logout. remove data from userdefaults
//
//                DispatchQueue.main.asyncAfter(deadline: .now()) {
//                    AppUtility.deleteLocalData()
//                    ApplicationRoot.shared.setAuthanticationModuleAsRoot()
//                }
//            }
//        }
    }
    
    
//    private func updateUserDetailToHubSpot() {
//        
//        let fullName = (nameTf.text?.isEmpty ?? false) ? (Contact.shared.fullname) : nameTf.text
//        
//        let emailAddress = (emailTf.text?.isEmpty ?? false) ? (Contact.shared.getProperties()?.email) : emailTf.text
//        
//        let phoneNo = (phoneNoTf.text?.isEmpty ?? false) ? (Contact.shared.getProperties()?.moon_app_num_edit) : phoneNoTf.text
//        
//        let birthDay = (birthdayTf.text?.isEmpty ?? false) ? (Contact.shared.getProperties()?.date_of_birth) : birthdayTf.text
//        
//        let address = (addressTf.text?.isEmpty ?? false) ? (Contact.shared.getProperties()?.address) : addressTf.text
//        
//        var properties: [String: Any] = [:]
//        properties["moon_app_num_edit"] = phoneNo
//        /*commeting below code as there is no clarity from UI Name input field will take first name or last name
//         //FIGMA link:-https://www.figma.com/design/We5kkBkXrUZZONkwwr03rw/Moon?node-id=8611-73387&t=LlI5mavstHS2RpVw-0
//         //https://itcandev.atlassian.net/browse/MOON-1456
//         properties["firstname"] = firstName
//         properties["lastname"] = lastName*/
//        properties["moon_email"] = emailAddress
//        properties["address"] = address
//        properties["date_of_birth"] = birthDay
//        let param = ["properties": properties]
//        print(param)
//        
//        CouponListService.updateUserDetailsInHubSpot(userid: Contact.shared.contactId ?? "", param: param) { response in
//            let currentUser = ConfigurationManager.shared.currentUser
//            currentUser?.moon_app_num_edit_hub = response.properties.moon_app_num_edit
//            currentUser?.moon_app_add_edit_hub = response.properties.moon_app_add_edit
//            currentUser?.moon_app_birth_edit_hub = response.properties.moon_app_birth_edit
////            currentUser?.first_name_hub = response.properties.firstname
////            currentUser?.last_name_hub = response.properties.lastname
//            currentUser?.birthDate = response.properties.date_of_birth
//            currentUser?.address = response.properties.address
//            
//            Contact.shared.updateUserDetails(user: currentUser!)
//            ConfigurationManager.shared.currentUser = currentUser
//            
//            let message =  APPLocalizable.usr_details_msg
//            
//            let alert = UIAlertController(title: APPLocalizable.app_title, message: message, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: APPLocalizable.ok, style: .default, handler: { _ in
//                self.navigationController?.popViewController(animated: true)
//            }))
//            self.present(alert, animated: true, completion: nil)
//            
//        } failure: { error in
//            print(error?.localizedDescription)
//            //            AppUtility.showToast(withMessage: error?.localizedDescription ?? "")
//        }
//    }
}

extension PersonalDetailsVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Define the allowed character set (English letters and numbers)
        let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ")

        // Ensure that only allowed characters are entered
        if string.rangeOfCharacter(from: allowedCharacterSet.inverted) != nil {
            showAlert(APPLocalizable.app_title,
                      message: APPLocalizable.english_val_msg,
                      actions: [APPLocalizable.ok: .default])
            return false  // Block non-English characters
        }

        return true
    }

}
