//
//  MainViewController.swift
//  Sense
//
//  Created by Andrea Bottino on 18/11/2023.
//

import UIKit
import FirebaseAuth
import UserNotifications

class MainViewController: UIViewController {
    
    
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var dailyIntentionsButton: UIButton!
    @IBOutlet weak var eveningReflectionsButton: UIButton!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    var timeOfDay = ""
    var currentDate = ""
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Notifications.dontShowAgain == false {
            Notifications.askForPermission(self)
        }
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkDatabase()
    }
    
    @IBAction func diaryEntryPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            timeOfDay = "am"
        } else {
            timeOfDay = "pm"
        }
        performSegue(withIdentifier: "makeEntry", sender: self)
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
    
    func setupUI() {
        title = "Sense"
        buttonsContainerView.layer.cornerRadius = buttonsContainerView.frame.width/30
        buttonsContainerView.clipsToBounds = true
        dailyIntentionsButton.titleLabel?.numberOfLines = 1
        eveningReflectionsButton.titleLabel?.numberOfLines = 1
        dailyIntentionsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        eveningReflectionsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        settingsButton.image = UIImage(systemName: "ellipsis.circle")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "makeEntry" {
            if let destinationVC = segue.destination as? DiaryEntryViewController {
                destinationVC.timeOfDay = timeOfDay
                destinationVC.editButton.isHidden = true
            }
        }
    }
}


