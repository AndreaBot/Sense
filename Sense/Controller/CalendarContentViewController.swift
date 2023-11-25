//
//  CalendarContentViewController.swift
//  Sense
//
//  Created by Andrea Bottino on 22/11/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth

protocol CalendarContentViewDelegate {
    func showDiaryEntryContent(_ buttonTitle: String)
}

class CalendarContentViewController: UIViewController {
    
    
    @IBOutlet weak var morningIntentionsButton: UIButton!
    @IBOutlet weak var eveningReflectionsButton: UIButton!
    
    var currentDate = ""
    var delegate: CalendarContentViewDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        morningIntentionsButton.isHidden = true
        eveningReflectionsButton.isHidden = true
        checkDatabase()
    }
    
    func checkDatabase() {
        if let userId = Auth.auth().currentUser?.uid {
            
            FirebaseMethods.Database.checkForDoc("am", currentDate, userId) { result in
                switch result {
                case(.success(())):
                    self.morningIntentionsButton.isHidden = false
                case(.failure((_))):
                    self.morningIntentionsButton.isHidden = true
                }
            }
            
            FirebaseMethods.Database.checkForDoc("pm", currentDate, userId) { result in
                switch result {
                case(.success(())):
                    self.eveningReflectionsButton.isHidden = false
                case(.failure((_))):
                    self.eveningReflectionsButton.isHidden = true
                }
            }
        }
    }
    
    @IBAction func diaryEntryPressed(_ sender: UIButton) {
        dismiss(animated: true)
        delegate?.showDiaryEntryContent(convertButtonTitleToDocName(sender.currentTitle!))
    }
    
    func convertButtonTitleToDocName(_ buttonTitle: String) -> String {
        if buttonTitle == "Morning Intentions" {
            return "am"
        } else {
            return "pm"
        }
    }
    
}
