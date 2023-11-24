//
//  Alerts.swift
//  Sense
//
//  Created by Andrea Bottino on 24/11/2023.
//

import UIKit

struct Alerts {
    
    static func showAlert(_ vc: UIViewController, _ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .cancel))
        vc.present(alert, animated: true)
    }
}
