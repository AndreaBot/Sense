//
//  CalendarContentViewController.swift
//  Sense
//
//  Created by Andrea Bottino on 22/11/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

protocol CalendarContentViewDelegate {
    func showDiaryEntryContent(_ buttonTitle: String)
}

class CalendarContentViewController: UIViewController {
    
    
    @IBOutlet weak var morningIntentionsButton: UIButton!
    @IBOutlet weak var eveningReflectionsButton: UIButton!
    
    var currentDate = ""
    var delegate: CalendarContentViewDelegate?
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkDatatabase()
    }
    
    func checkDatatabase() {
        morningIntentionsButton.isHidden = true
        eveningReflectionsButton.isHidden = true
        if let userId = Auth.auth().currentUser?.uid {
            let databaseContent = db.collection(userId).document(currentDate).collection(currentDate)
            let amDoc = databaseContent.document("am")
            let pmDoc = databaseContent.document("pm")
            
            amDoc.getDocument { document , error in
                if let document = document, document.exists {
                    self.morningIntentionsButton.isHidden = false
                }
            }
            pmDoc.getDocument { document , error in
                if let document = document, document.exists {
                    self.eveningReflectionsButton.isHidden = false
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
