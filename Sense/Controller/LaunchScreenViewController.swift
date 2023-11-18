//
//  LaunchScreenViewController.swift
//  Sense
//
//  Created by Andrea Bottino on 18/11/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
            
            if Auth.auth().currentUser != nil {
                performSegue(withIdentifier: "goToDiary", sender: self)
            } else {
                performSegue(withIdentifier: "goToUser", sender: self)
            }
        }
    }
   
}
