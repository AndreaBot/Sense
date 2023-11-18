//
//  MainViewController.swift
//  Sense
//
//  Created by Andrea Bottino on 18/11/2023.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    @IBAction func logout(_ sender: UIButton) {
        logoutUser()
    }
    
    
    
    func logoutUser() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
           self.resetVC()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

    func resetVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let targetViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        let navigationController = UINavigationController(rootViewController: targetViewController)
        navigationController.modalPresentationStyle = .fullScreen
        UINavigationBar.appearance().tintColor = .black
        self.present(navigationController, animated: true, completion: nil)
    }

}
