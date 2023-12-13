//
//  Alerts.swift
//  Sense
//
//  Created by Andrea Bottino on 24/11/2023.
//

import UIKit

struct Alerts {
    
    static func errorAlert(_ message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .cancel))
        return alert
    }
    
    static func confirmationMessage() -> UIAlertController {
        let confimationImage = UIImage(systemName: "checkmark.circle")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Diary entry saved!", style: .default)
        action.setValue(confimationImage, forKey: "image")
        alert.addAction(action)
        return alert
    }
    
    static func notificationsAlert(_ title: String, _ message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { _ in
            AppLogic.dontShowAgain = false
            AppLogic.updateUserDefaults()
        }))
        alert.addAction(UIAlertAction(title: "Don't ask me again", style: .cancel, handler: { _ in
            AppLogic.dontShowAgain = true
            AppLogic.updateUserDefaults()
        }))
        return alert
    }
}
