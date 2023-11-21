//
//  EveningReflectionsViewController.swift
//  Sense
//
//  Created by Andrea Bottino on 18/11/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class DiaryEntryViewController: UIViewController {


    @IBOutlet weak var txtField1: UITextField!
    @IBOutlet weak var txtField2: UITextField!
    @IBOutlet weak var txtField3: UITextField!
    @IBOutlet weak var txtField4: UITextField!
    @IBOutlet weak var txtField5: UITextField!
    @IBOutlet weak var txtField6: UITextField!
    @IBOutlet weak var diaryEntry: UITextView!
    
    var mood = ""
    var currentDate = ""
    var timeOfDay = "pm"
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "TEST"
    }
    
    
    @IBAction func moodTracker(_ sender: UIButton) {
        switch sender.tag {
        case 1: mood = "happy"
        case 2: mood = "neutral"
        case 3: mood = "sad"
        default: mood = "neutral"
        }
    }
    
    @IBAction func saveButtonpressed(_ sender: UIBarButtonItem) {
        currentDate = getDate()
        
        if let userId = Auth.auth().currentUser?.uid,
           let text1 = txtField1.text,
           let text2 = txtField2.text,
           let text3 = txtField3.text,
           let text4 = txtField4.text,
           let text5 = txtField5.text,
           let text6 = txtField6.text,
           let diaryText = diaryEntry.text {
            
            db.collection(userId).document(currentDate).collection(currentDate).document(timeOfDay).setData([
                "mood": mood,
                "txtField1": text1,
                "txtField2": text2,
                "txtField3": text3,
                "txtField4": text4,
                "txtField5": text5,
                "txtField6": text6,
                "diaryEntry": diaryText
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
    }
    
    func getDate() -> String {
        let date = Date()
        let calendar = Calendar.current
        let day = String(calendar.component(.day, from: date))
        let month = String(calendar.component(.month, from: date))
        let year = String(calendar.component(.year, from: date))
        return day+month+year
    }
}
