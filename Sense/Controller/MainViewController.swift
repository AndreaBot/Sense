//
//  MainViewController.swift
//  Sense
//
//  Created by Andrea Bottino on 18/11/2023.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    
    var screenTitle = ""
    var timeOfDay = ""
    var firstLabelText = ""
    var secondLabelText = ""
    var backgroundColor = UIColor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func diaryEntryPressed(_ sender: UIButton) {
        screenTitle = sender.currentTitle!
        
        if sender.currentTitle == "Daily Intensions" {
            timeOfDay = "am"
            firstLabelText = "Today's positive intentions"
            secondLabelText = "Top 3 To-Do's"
            backgroundColor = UIColor.systemYellow
        } else {
            timeOfDay = "pm"
            firstLabelText = "Three things I did well today"
            secondLabelText = "Three thing I could improve on"
            backgroundColor = UIColor.systemPurple
        }
        performSegue(withIdentifier: "makeEntry", sender: self)
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
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
        self.present(navigationController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "makeEntry" {
            let destinationVC = segue.destination as? DiaryEntryViewController
            destinationVC?.screenTitle = screenTitle
            destinationVC?.timeOfDay = timeOfDay
            destinationVC?.firstLabelText = firstLabelText
            destinationVC?.secondLabelText = secondLabelText
            destinationVC?.backgroundColor = backgroundColor
            destinationVC?.editButton.isHidden = true
        }
    }
    
}


