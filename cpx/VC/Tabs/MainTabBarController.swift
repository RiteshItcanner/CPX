//
//  MainTabBarController.swift
//  cpx
//
//  Created by Ritesh Sinha on 16/09/24.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("tab bar initiated")
        fetchUserAndBankDetails()
        self.delegate = self
 
    }
    
    private func fetchUserAndBankDetails() {
        let dispatchGroup = DispatchGroup() // Create a dispatch group to manage the API requests
        
        var bankDetailsSuccess = false
        var userDetailsSuccess = false

        let userId = UserSessionManager.shared.userId ?? ""
        let intUserId = Int(userId) ?? 0
        
//        SVProgressHUD.show()
        
        // Start fetching Bank Details
        dispatchGroup.enter() // Enter the group before starting the API call
        APIService.shared.getBankDetails(userId: intUserId) { result in
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
                bankDetailsSuccess = true
            case .failure(let otpError):
                print("Error fetching Bank details: \(otpError.message)")
                self.showAlert(APPLocalizable.app_title, message: otpError.message)
            }
            dispatchGroup.leave() // Leave the group once the API call finishes
        }
        
        // Start fetching User Details
        dispatchGroup.enter() // Enter the group before starting the API call
        APIService.shared.getUserDetails(userId: intUserId) { result in
            switch result {
            case .success(let couponResponse):
                print("User details successfully: \(couponResponse)")
                let email = couponResponse.data.email ?? ""
                let phone = couponResponse.data.phone ?? ""
                let address = couponResponse.data.address1 ?? ""
                let name = couponResponse.data.name ?? ""
                let birthday = couponResponse.data.birth_date ?? ""
                
                UserSessionManager.shared.saveUserDetails(email: email, name: name, phone: phone, birthday: birthday, address: address)
                userDetailsSuccess = true
            case .failure(let otpError):
                print("Error fetching User details: \(otpError.message)")
                self.showAlert(APPLocalizable.app_title, message: otpError.message)
            }
            dispatchGroup.leave() // Leave the group once the API call finishes
        }
        
        // Notify when both API calls are completed
        dispatchGroup.notify(queue: .main) {
//            SVProgressHUD.dismiss() // Dismiss the loader once both API calls are done
            
            if bankDetailsSuccess && userDetailsSuccess {
                // Both API calls succeeded
//                self.setDetails() // Update the UI after fetching both details
                print("User and Bank Details API fetched successfully")
            } else {
                // One or both API calls failed
                print("Error fetching details from User or Bank Details API")
            }
        }
    }

    
    // This method is called whenever a tab bar item is selected
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Detect which tab was selected
        if let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) {
            print("Selected tab index: \(selectedIndex)")
            let userId = UserSessionManager.shared.userId ?? ""
            if selectedIndex == 0 {
                SDKAnalyticsManager.shared.trackEvent(TabbarEvent.myCouponsNav,
                                                      params: ["contact_id":userId])
            } else if selectedIndex == 1 {
                SDKAnalyticsManager.shared.trackEvent(TabbarEvent.statsNav,
                                                      params: ["contact_id":userId])
            } else if selectedIndex == 2 {
                SDKAnalyticsManager.shared.trackEvent(TabbarEvent.notifNav,
                                                      params: ["contact_id":userId])
            } else {
                SDKAnalyticsManager.shared.trackEvent(TabbarEvent.accountNav,
                                                      params: ["contact_id":userId])
            }
            
            // Perform any action based on the selected tab
        }
    }
    
    
}
