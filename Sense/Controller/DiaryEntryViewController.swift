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
    
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var happyMoodButton: UIButton!
    @IBOutlet weak var neutralMoodButton: UIButton!
    @IBOutlet weak var sadMoodButton: UIButton!
    
    @IBOutlet weak var txtField1: UITextField!
    @IBOutlet weak var txtField2: UITextField!
    @IBOutlet weak var txtField3: UITextField!
    @IBOutlet weak var txtField4: UITextField!
    @IBOutlet weak var txtField5: UITextField!
    @IBOutlet weak var txtField6: UITextField!
    @IBOutlet weak var diaryEntry: UITextView!
    
    var mood = ""
    var currentDate = ""
    
    var screenTitle = ""
    var timeOfDay = ""
    var firstLabelText = ""
    var secondLabelText = ""
    var backgroundColor = UIColor.systemGray
    var entryContent: DiaryEntryModel?
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = backgroundColor
        if currentDate == "" {
            currentDate = getDate()
        }
        fillView()
    }
    
    
    @IBAction func moodTracker(_ sender: UIButton) {
        switch sender.tag {
        case 1: mood = "happy"
        case 2: mood = "neutral"
        case 3: mood = "sad"
        default: mood = "neutral"
        }
        highlightSelectedMood(mood)
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if sender.title == "Edit" {
            sender.title = "Cancel"
            view.isUserInteractionEnabled = true
            saveButton.isEnabled = true
        } else {
            sender.title = "Edit"
            view.isUserInteractionEnabled = false
            saveButton.isEnabled = false
        }
    }
    
    
    @IBAction func saveButtonpressed(_ sender: UIBarButtonItem) {
        
        if let userId = Auth.auth().currentUser?.uid,
           let text1 = txtField1.text,
           let text2 = txtField2.text,
           let text3 = txtField3.text,
           let text4 = txtField4.text,
           let text5 = txtField5.text,
           let text6 = txtField6.text,
           let diaryText = diaryEntry.text {
            
            db.collection(userId).document(currentDate).collection(currentDate).document(timeOfDay).setData([
                "timeOfDay": timeOfDay,
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
                    self.showConfirmationMessage()
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
    
    func fillView() {
        if let passedContent = entryContent {
            txtField1.text = passedContent.txtField1
            txtField2.text = passedContent.txtField2
            txtField3.text = passedContent.txtField3
            txtField4.text = passedContent.txtField4
            txtField5.text = passedContent.txtField5
            txtField6.text = passedContent.txtField6
            diaryEntry.text = passedContent.diaryText
            
            highlightSelectedMood(passedContent.mood!)
            
            title = convertTitleText(passedContent.timeOfDay!)
            firstLabel.text = convertFirstLabelText((passedContent.timeOfDay)!)
            secondLabel.text = convertSecondLabelText((passedContent.timeOfDay)!)
            
            view.isUserInteractionEnabled = false
            
        } else {
            title = screenTitle
            firstLabel.text = firstLabelText
            secondLabel.text = secondLabelText
        }
    }
    
    func convertTitleText(_ timeofDay: String) -> String {
        if timeofDay == "am" {
            return "Daily Intentions"
        } else {
            return "Evening Reflections"
        }
    }
    
    func convertFirstLabelText(_ timeofDay: String) -> String {
        if timeofDay == "am" {
            return "Today's positive intentions"
        } else {
            return "Three things I did well today"
        }
    }
    
    func convertSecondLabelText(_ timeofDay: String) -> String {
        if timeofDay == "am" {
            return "Top 3 To-Do's"
        } else {
            return "Three thing I could improve on"
        }
    }
    
    func highlightSelectedMood(_ mood: String) {
        if mood == "happy" {
            enableButton(happyMoodButton)
            disableButton(neutralMoodButton)
            disableButton(sadMoodButton)
        } else if mood == "neutral" {
            disableButton(happyMoodButton)
            enableButton(neutralMoodButton)
            disableButton(sadMoodButton)
        } else if mood == "sad" {
            disableButton(happyMoodButton)
            disableButton(neutralMoodButton)
            enableButton(sadMoodButton)
        }
    }
    
    func enableButton(_ button: UIButton) {
        button.layer.borderColor = CGColor(red: 0, green: 0.7, blue: 1, alpha: 1)
        button.layer.cornerRadius = happyMoodButton.frame.height/2
        button.layer.borderWidth = happyMoodButton.frame.height/8
        button.alpha = 1
    }
    
    func disableButton(_ button: UIButton) {
        button.layer.borderWidth = 0
        button.alpha = 0.4
    }
    
    func showConfirmationMessage() {
        let confimationImage = UIImage(systemName: "checkmark.circle")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        let confirmationMessage = "Diary entry saved!"
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "", style: .default)
        action.setValue(confimationImage, forKey: "image")
        action.setValue(confirmationMessage, forKey: "title")
        alert.addAction(action)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.dismiss(animated: true)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
