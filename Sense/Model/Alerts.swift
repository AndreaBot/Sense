//
//  Alerts.swift
//  Sense
//
//  Created by Andrea Bottino on 24/11/2023.
//

import FirebaseAuth
import UIKit

struct Alerts {
    
    static func errorAlert(_ message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .cancel))
        return alert
    }
    
    static func confirmationMessage(_ title: String) -> UIAlertController {
        let confimationImage = UIImage(systemName: "checkmark.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))?.withTintColor(UIColor(named: "CustomPinkColor")!, renderingMode: .alwaysOriginal)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: title, style: .default)
        action.setValue(confimationImage, forKey: "image")
        alert.addAction(action)
        alert.view.tintColor = .label
        return alert
    }
    
    static func notificationsAlert(_ title: String, _ message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { _ in
            Notifications.dontShowAgain = false
            Notifications.updateShowAgainUserDefaults()
        }))
        alert.addAction(UIAlertAction(title: "Don't remind me again", style: .cancel, handler: { _ in
            Notifications.dontShowAgain = true
            Notifications.updateShowAgainUserDefaults()
        }))
        return alert
    }
    
    static func confirmationAlert(_ vc: UIViewController) -> UIAlertController {
        let alert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account? This cannot be undone.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            FirebaseMethods.Authentication.deleteAccount { result in
                switch result {
                case .failure(let error as NSError):
                    if let code = AuthErrorCode.Code(rawValue: error.code) {
                        vc.present(Alerts.errorAlert(FirebaseAuthErrors.presentError(using: code)), animated: true)
                    }
                case .success(()):
                    AppLogic.resetVC(vc)
                }
            }
        }))
        return alert
    }
    
    static func passwordResetAlert(vc: LoginViewController) -> UIAlertController {
        let alert = UIAlertController(title: "Password reset", message: "Where should we send the password reset link?", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter your email address here"
            textField.text = vc.emailAddress
            textField.delegate = vc
        }
        let confirmAction = UIAlertAction(title: "Send reset link", style: .default) { UIAlertAction in
            FirebaseMethods.Authentication.sendPasswordResetEmail(to: vc.emailAddress) { result in
                switch result {
                case .success():
                    vc.present(Alerts.confirmationMessage("Email succcessfully sent!"), animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        vc.dismiss(animated: true)
                    }
                case .failure(let error as NSError):
                    if let code = AuthErrorCode.Code(rawValue: error.code) {
                        vc.present(Alerts.errorAlert(FirebaseAuthErrors.presentError(using: code)), animated: true)
                    }
                }
            }
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(confirmAction)
        return alert
    }
}

