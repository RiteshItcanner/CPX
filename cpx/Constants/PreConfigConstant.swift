//
//  PreConfigConstant.swift
//  LalaCoupons
//
//  Created by PYTHON on 28/08/23.
//  Copyright © 2023 Lala. All rights reserved.
//

import UIKit

struct PreConfigConstant {
    static var bounds: CGRect {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let bounds = windowScene.windows.first?.screen.bounds {
            return bounds
        }
        return .zero
    }

    static var rootcontroller: UIViewController? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            // Use the rootViewController here
            return rootViewController
        }
        return nil
    }
    
    static func findPresentedViewController(_ vc: UIViewController)
        -> UIViewController {
        if let nc = vc as? UINavigationController {
            if let visible = nc.topViewController {
                return findPresentedViewController(visible)
            }
        } else if let tbc = vc as? UITabBarController {
            if let selected = tbc.selectedViewController {
                return findPresentedViewController(selected)
            }
        }

        if let presented = vc.presentedViewController,
           !presented.isBeingDismissed, presented.popoverPresentationController == nil {
            return findPresentedViewController(presented)
        }

        for child in vc.children {
            return findPresentedViewController(child)
        }

        return vc
    }

}
