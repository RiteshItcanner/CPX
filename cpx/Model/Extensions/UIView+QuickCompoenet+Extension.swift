//
//  UIView+QuickCompoenet+Extension.swift
//  Moon
//
//  Created by PYTHON on 22/12/23.
//

import AVFoundation
import Foundation
import UIKit

extension UIView {
    func loadVideoOnLayerFromFileURL(_ urlString: String) -> AVPlayerLayer? {
        let videoURL = URL(fileURLWithPath: urlString)
        return loadVideoOnLayer(videoURL)
    }

    func loadVideoOnLayerFromServerURL(_ urlString: String) -> AVPlayerLayer? {
        guard let videoURL = URL(string: urlString) else { return nil }
        return loadVideoOnLayer(videoURL)
    }

    private func loadVideoOnLayer(_ url: URL) -> AVPlayerLayer? {
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(origin: .zero,
                                   size: frame.size)
        playerLayer.contentsGravity = .resizeAspectFill
        return playerLayer
    }
}

extension UIViewController {
    
    func showAlert(_ title: String?,
                   message: String?,
                   actions: [String: UIAlertAction.Style] = [:],
                   handler: ((UIAlertAction) -> Void)? = nil,
                   textFields: [((UITextField) -> Void)] = []) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if actions.isEmpty {
            alert.addAction(UIAlertAction(title: APPLocalizable.ok, style: .default))
        } else {
            for action in actions {
                alert.addAction(UIAlertAction(title: action.key, style: action.value, handler: handler))
            }
        }
        for textField in textFields {
            alert.addTextField(configurationHandler: textField)
        }
        present(alert, animated: true)
    }
}
