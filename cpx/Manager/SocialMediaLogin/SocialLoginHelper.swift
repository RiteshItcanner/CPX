//
//  SocialLoginHelper.swift
//  Saudi Coupon
//
//  Created by baps on 23/10/19.
//  Copyright © 2019 Appbirds. All rights reserved.
//

// import FBSDKLoginKit
import AuthenticationServices
import Firebase
import GoogleSignIn // Google
import UIKit

protocol SocialLoginHelperDelegate {
    func didSocialLogin(for network: SocialLoginHelper.SocialNetwork, token: String!, identityToken: String!, user: User!)
}

protocol SocialLoginFailDelegate {
    func didFailSocialLogin(for network: SocialLoginHelper.SocialNetwork, error: Error?, isSilentError: Bool)
}

class SocialLoginHelper: NSObject {
    enum SocialNetwork: Int {
        case facebook = 1
        case google = 2
        case magento = 0
        case apple = 3
        case manual = 4
    }

    static let shared = SocialLoginHelper()
    var delegate: SocialLoginHelperDelegate?
    var delegateFail: SocialLoginFailDelegate?

    override private init() { }

    func loginWithApple(from: UIViewController) {
        guard let vc = from as? LoginVC else {return}
        self.delegate = vc
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        }
    }

    func logout() {
        GoogleSignIn.GIDSignIn.sharedInstance.signOut()
    }
}

extension SocialLoginHelper: ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // unique ID for each user, this uniqueID will always be returned
            DispatchQueue.main.async {
                var identityToken = credential.user
                let userid = credential.user
                let email = credential.email ?? Keychain.email ?? ""
                let firstName = credential.fullName?.givenName ?? Keychain.firstName ?? ""
                let lastName = credential.fullName?.familyName ?? Keychain.lastName ?? ""
                Keychain.userid = userid
                Keychain.firstName = firstName
                Keychain.lastName = lastName
                Keychain.email = email
                let user = User()
                user.user_email = email
                user.user_name = firstName
                if let authCode = String(data: credential.authorizationCode!,
                                         encoding: .utf8) {
                    print("authorizationCode \(authCode)")
                }

                if let identityTokenData = credential.identityToken,
                   let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
                    print("Identity Token \(identityTokenString)")
                    identityToken = identityTokenString
                }

                self.delegate?.didSocialLogin(for: .apple, token: userid, identityToken: identityToken, user: user)
            }
        }
    }

    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        delegateFail?.didFailSocialLogin(for: .apple, error: error, isSilentError: true)
    }
}

// GIDSignInDelegate
extension SocialLoginHelper {
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//        MoonInstance.shared.hideProcess()
        delegateFail?.didFailSocialLogin(for: .google, error: error, isSilentError: false)
    }

    func GIDSignIn(viewController: UIViewController) {
        if let _delegate = viewController as? SocialLoginHelperDelegate {
            delegate = _delegate
        }
        if let id = FirebaseApp.app()?.options.clientID {
            let signInConfig = GIDConfiguration(clientID: id)

            GoogleSignIn.GIDSignIn.sharedInstance.configuration = signInConfig
            GoogleSignIn.GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { user, _ in

                guard user != nil else {
                    // Inspect error
                    return
                }
//                MoonInstance.shared.showProcess(vc: viewController)
                // If sign in succeeded, display the app's main content View.
                guard let user = user else { return }
                self.setlogin(userData: user)
            }
        }
    }

    func setlogin(userData: GIDSignInResult) {
        if let profiledata = userData.user.profile {
            print(profiledata.email)
            print(profiledata.name)
            print(profiledata.givenName)

            // Perform any operations on signed in user here.
            let userId = userData.user.userID // For client-side use only!
            let idToken = userData.user.idToken?.tokenString // Safe to send to the server

            print(userData.user.userID)
            print(userData.user.idToken?.tokenString)

            let fullName = profiledata.name
            let email = profiledata.email

            let user = User()
            user.user_email = email
            if fullName.isEmpty == false {
                let names = fullName.components(separatedBy: " ")
                user.user_name = names.first ?? ""
            } else {
                user.user_name = fullName
            }

            delegate?.didSocialLogin(for: .google,
                                     token: idToken,
                                     identityToken: userId,
                                     user: user)
        }
    }

    func logOut() {
        GoogleSignIn.GIDSignIn.sharedInstance.signOut()
    }
}
