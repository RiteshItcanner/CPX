//
//  BankDetailsVC.swift
//  cpx
//
//  Created by Ritesh Sinha on 18/09/24.
//

import UIKit
import SVProgressHUD

class BankDetailsVC: UIViewController {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblAccHolderName: UILabel!
    @IBOutlet var txtAccHolderName: UITextField!
    @IBOutlet var lblAccNumber: UILabel!
    @IBOutlet var txtAccNumber: UITextField!
    @IBOutlet var lblBankName: UILabel!
    @IBOutlet var txtBankName: UITextField!
    @IBOutlet var lblBan: UILabel!
    @IBOutlet var txrBan: UITextField!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var btnBack: UIButton!

    @IBOutlet var lblBankBranch: UILabel!
    @IBOutlet var txtBankBranch: UITextField!

    @IBOutlet var lblCountry: UILabel!
    @IBOutlet var txtBankCountry: UITextField!

    @IBOutlet var lblSwiftCode: UILabel!
    @IBOutlet var txtSwiftCode: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setDetails()
    }
    
    private func fetchBankDetails() {
        let userId = UserSessionManager.shared.userId ?? ""
        let intUserId = Int(userId) ?? 0
        SVProgressHUD.show()
        APIService.shared.getBankDetails(userId: intUserId) { result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(let couponResponse):
                print("Bank details successfully: \(couponResponse)")
                let accountHolderName = couponResponse.data.beneficiaryName
                let accountNumber = couponResponse.data.accountNumber
                let bankName = couponResponse.data.bankName
                let bankBranch = couponResponse.data.bankBranch
                let bankCountry = couponResponse.data.bankCountry
                let iban = couponResponse.data.ibanNumber
                let swiftCode = couponResponse.data.swiftNumber
                
                UserSessionManager.shared.saveBankDetails(accountHolderName: accountHolderName, accountNumber: accountNumber, bankName: bankName, bankBranch: bankBranch, bankCountry: bankCountry, iban: iban, swiftCode: swiftCode)
                self.setDetails()

            case .failure(let otpError):
                print("Error fetching Bank details: \(otpError.message)")
                self.showAlert(APPLocalizable.app_title, message: otpError.message)
            }
        }
    }
    
    private func setDetails() {
        let bankDetails = UserSessionManager.shared.getBankDetails()
        self.txtAccHolderName.text = bankDetails.accountHolderName
        self.txtAccNumber.text = bankDetails.accountNumber
        self.txtBankName.text = bankDetails.bankName
        self.txtBankBranch.text = bankDetails.bankBranch
        self.txtBankCountry.text = bankDetails.bankCountry
        self.txrBan.text = bankDetails.iban
        self.txtSwiftCode.text = bankDetails.swiftCode
    }
    

    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
