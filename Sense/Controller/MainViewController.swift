//
//  MainViewController.swift
//  Sense
//
//  Created by Andrea Bottino on 18/11/2023.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    
    
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var dailyIntentionsButton: UIButton!
    @IBOutlet weak var eveningReflectionsButton: UIButton!
    
    var screenTitle = ""
    var timeOfDay = ""
    var firstLabelText = ""
    var secondLabelText = ""
    var backgroundColor = UIColor()
    var currentDate = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
// self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Apricot-Alternates", size: 15)!]
        title = "Sense"
        buttonsContainerView.layer.cornerRadius = buttonsContainerView.frame.height/30
        buttonsContainerView.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkDatabase()
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
        FirebaseMethods.Authentication.logout { result in
            switch result {
            case .success(): self.resetVC()
            case .failure(let error): self.present(Alerts.errorAlert(error.localizedDescription), animated: true)
            }
        }
    }
    
    func resetVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let targetViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        let navigationController = UINavigationController(rootViewController: targetViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func checkDatabase() {
        if let userId = Auth.auth().currentUser?.uid {
            currentDate = AppLogic.getDate()
            
            FirebaseMethods.Database.checkForDoc("am", self.currentDate, userId) { result in
                switch result {
                case(.success(())):
                    self.dailyIntentionsButton.isEnabled = false
                case(.failure((_))):
                    self.dailyIntentionsButton.isEnabled = true
                    AppLogic.enableAmBasedOnTime(self.dailyIntentionsButton)
                }
                
                FirebaseMethods.Database.checkForDoc("pm", self.currentDate, userId) { result in
                    switch result {
                    case(.success(())):
                        self.eveningReflectionsButton.isEnabled = false
                    case(.failure((_))):
                        self.eveningReflectionsButton.isEnabled = true
                        AppLogic.enablePmBasedOnTime(self.eveningReflectionsButton)
                    }
                }
            }
        }
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


