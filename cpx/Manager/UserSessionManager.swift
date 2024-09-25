//
//  UserSessionManager.swift
//  cpx
//
//  Created by Ritesh Sinha on 17/09/24.
//

class UserSessionManager {
    
    static let shared = UserSessionManager()
    
    private let userDefaultsManager = UserDefaultsManager()
    private var userData: ConfirmOTPData?
    
    
    var email: String?
    var phone: String?
    var company: String?
    var name: String?
    var birthday: String?
    var address: String?
    
    var accountHolderName: String?
    var accountNumber: String?
    var bankName: String?
    var bankBranch: String?
    var bankCountry: String?
    var iban: String?
    var swiftCode: String?
    
    private init() {
        // Load the user data when the app starts
        loadUserData()
    }
    
    // Load the ConfirmOTPData from UserDefaults
    private func loadUserData() {
        if let data: ConfirmOTPData = userDefaultsManager.load(ConfirmOTPData.self, forKey: "UserData") {
            self.userData = data
        }
    }
    
    // Get the user ID
    var userId: String? {
        return userData?.id
    }
    
    // Get the user email
    var userEmail: String? {
        return userData?.email
    }
    
    // Any other user-related data you want to access globally
    
    
    
    // Clear user session on logout
    func clearUserData() {
        userDefaultsManager.remove(forKey: "UserData")
        userData = nil
    }
    
    func saveUserDetails(email: String, name: String, phone: String, birthday: String, address: String) {
        self.email = email
        self.name = name
        self.phone = phone
        self.birthday = birthday
        self.address = address
    }
    
    func getUserDetails() -> (email: String?, name: String?, phone: String?, birthday: String?, address: String?) {
        return (email, name, phone, birthday, address)
    }
    
    func saveBankDetails(accountHolderName: String, accountNumber: String, bankName: String, bankBranch: String, bankCountry: String, iban: String, swiftCode: String) {
        self.accountHolderName = accountHolderName
        self.accountNumber = accountNumber
        self.bankName = bankName
        self.bankBranch = bankBranch
        self.bankCountry = bankCountry
        self.iban = iban
        self.swiftCode = swiftCode
    }
    
    func getBankDetails() -> (accountHolderName: String?, accountNumber: String?, bankName: String?, bankBranch: String?, bankCountry: String?, iban: String?, swiftCode: String?) {
        return (accountHolderName, accountNumber, bankName, bankBranch, bankCountry, iban, swiftCode)
    }
    
    // Function to check for the first empty key and count of empty keys
    func firstEmptyKeyAndNonEmptyCount() -> (firstEmptyKey: String?, nonEmptyCount: Int) {
        var nonEmptyCount = 0
        var firstEmptyKey: String?
        
        // Check user details first
        if let email = email, !email.isEmpty {
            nonEmptyCount += 1
        } else {
            firstEmptyKey = firstEmptyKey ?? "Email"
        }
        
        if let name = name, !name.isEmpty {
            nonEmptyCount += 1
        } else {
            firstEmptyKey = firstEmptyKey ?? "Name"
        }
        
        if let phone = phone, !phone.isEmpty {
            nonEmptyCount += 1
        } else {
            firstEmptyKey = firstEmptyKey ?? "Phone"
        }
        
        if let birthday = birthday, !birthday.isEmpty {
            nonEmptyCount += 1
        } else {
            firstEmptyKey = firstEmptyKey ?? "Birthday"
        }
        
        if let address = address, !address.isEmpty {
            nonEmptyCount += 1
        } else {
            firstEmptyKey = firstEmptyKey ?? "Address"
        }
        
        // Check bank details next
        if let accountHolderName = accountHolderName, !accountHolderName.isEmpty {
            nonEmptyCount += 1
        } else {
            firstEmptyKey = firstEmptyKey ?? "Account Holder Name"
        }
        
        if let accountNumber = accountNumber, !accountNumber.isEmpty {
            nonEmptyCount += 1
        } else {
            firstEmptyKey = firstEmptyKey ?? "Account Number"
        }
        
        if let bankName = bankName, !bankName.isEmpty {
            nonEmptyCount += 1
        } else {
            firstEmptyKey = firstEmptyKey ?? "Bank Name"
        }
        
        if let bankBranch = bankBranch, !bankBranch.isEmpty {
            nonEmptyCount += 1
        } else {
            firstEmptyKey = firstEmptyKey ?? "Bank Branch"
        }
        
        if let bankCountry = bankCountry, !bankCountry.isEmpty {
            nonEmptyCount += 1
        } else {
            firstEmptyKey = firstEmptyKey ?? "Bank Country"
        }
        
        if let iban = iban, !iban.isEmpty {
            nonEmptyCount += 1
        } else {
            firstEmptyKey = firstEmptyKey ?? "Iban"
        }
        
        if let swiftCode = swiftCode, !swiftCode.isEmpty {
            nonEmptyCount += 1
        } else {
            firstEmptyKey = firstEmptyKey ?? "Swift Code"
        }
        
        // Return the first empty key and the count of non-empty keys
        return (firstEmptyKey, nonEmptyCount)
    }
    
}

