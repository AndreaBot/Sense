//
//  EveningReflectionsViewController.swift
//  Sense
//
//  Created by Andrea Bottino on 18/11/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth

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
    @IBOutlet var containerViews: [UIView]!
    
    var mood = ""
    var currentDate = ""
    var screenTitle = ""
    var timeOfDay = ""
    var firstLabelText = ""
    var secondLabelText = ""
    var containerViewsBackgroundColor = UIColor()
    var entryContent: DiaryEntryModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentDate == "" {
            currentDate = AppLogic.getDate()
        }
        setupView()
        let exitKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(exitKeyboard)
        for container in containerViews {
            container.backgroundColor = containerViewsBackgroundColor
            container.layer.cornerRadius = container.frame.width/35
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
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
            
            FirebaseMethods.Database.writeToDatabase(currentDate, timeOfDay, mood, userId, text1, text2, text3, text4, text5, text6, diaryText) { result in
                switch result {
                case .success():
                    print("Document successfully written!")
                    self.present(Alerts.confirmationMessage(), animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.dismiss(animated: true)
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    print("Error writing document: \(error)")
                }
            }
        }
    }
    
    func setupView() {
        if let passedContent = entryContent {
            txtField1.text = passedContent.txtField1
            txtField2.text = passedContent.txtField2
            txtField3.text = passedContent.txtField3
            txtField4.text = passedContent.txtField4
            txtField5.text = passedContent.txtField5
            txtField6.text = passedContent.txtField6
            diaryEntry.text = passedContent.diaryText
            
            highlightSelectedMood(passedContent.mood!)
            
            title = AppLogic.convertTitleText(passedContent.timeOfDay!)
            firstLabel.text = AppLogic.convertFirstLabelText((passedContent.timeOfDay)!)
            secondLabel.text = AppLogic.convertSecondLabelText((passedContent.timeOfDay)!)
            
            view.isUserInteractionEnabled = false
            
        } else {
            title = screenTitle
            firstLabel.text = firstLabelText
            secondLabel.text = secondLabelText
        }
        txtField1.delegate = self
        txtField2.delegate = self
        txtField3.delegate = self
        txtField4.delegate = self
        txtField5.delegate = self
        txtField6.delegate = self
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
        button.layer.borderColor = UIColor(named: "PinkColor")?.cgColor
        button.layer.cornerRadius = happyMoodButton.frame.height/2
        button.layer.borderWidth = happyMoodButton.frame.height/8
        button.alpha = 1
    }
    
    func disableButton(_ button: UIButton) {
        button.layer.borderWidth = 0
        button.alpha = 0.4
    }
}

extension DiaryEntryViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

