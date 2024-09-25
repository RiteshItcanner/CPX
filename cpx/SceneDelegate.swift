//
//  SceneDelegate.swift
//  cpx
//
//  Created by Ritesh Sinha on 16/09/24.
//

import UIKit
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        
//        window = UIWindow(windowScene: windowScene)
        let userDefaultsManager = UserDefaultsManager()

        // Load ConfirmOTPData from UserDefaults
        if let confirmOTPData: ConfirmOTPData = userDefaultsManager.load(ConfirmOTPData.self, forKey: "UserData") {
            // Use the loaded data
            print("User ID: \(confirmOTPData.id)")
            print("User Email: \(confirmOTPData.email)")
            if confirmOTPData.id != ""{
                showMainTabBar()
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "OnBoardingVC") as! OnBoardingVC
//                changeRootViewController(to: vc)
            }
            // You can access other properties as needed
        } else {
            print("No data found in UserDefaults")
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
            print("Number of view controllers: \(tabBarController.viewControllers?.count ?? 0)")
            changeRootViewController(to: tabBarController)
        }
    }
    
    func changeRootViewController(to viewController: UIViewController) {
        guard let window = self.window else { return }
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.isNavigationBarHidden = true
//        window.rootViewController = viewController
//        window.makeKeyAndVisible()
        
        // Animate the transition to the new root view controller
        UIView.transition(with: window,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
            window.rootViewController = navigationController
        },
                          completion: nil)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        GIDSignIn.sharedInstance.handle(url)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

