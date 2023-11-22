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

class CalendarContentViewController: UIViewController {
    
    
    @IBOutlet weak var morningIntentionsButton: UIButton!
    @IBOutlet weak var eveningReflectionsButton: UIButton!
    
    var currentDate = ""
    
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
}
