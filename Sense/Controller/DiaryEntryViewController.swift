//
//  EveningReflectionsViewController.swift
//  Sense
//
//  Created by Andrea Bottino on 18/11/2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

enum Mood: String {
    case happy, neutral, sad
}

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
    @IBOutlet weak var expandButton: UIButton!
    
    var mood: Mood = .neutral
    
    var currentDate = ""
    
    var timeOfDay = ""
    var screenTitle: String {
        AppLogic.convertAmPm(timeOfDay).title
    }
    var firstLabelText: String {
        AppLogic.convertAmPm(timeOfDay).firstHeader
    }
    var secondLabelText: String {
        AppLogic.convertAmPm(timeOfDay).secondHeader
    }
    var containerViewsBackgroundColor: UIColor {
        AppLogic.convertAmPm(timeOfDay).backgroundColor
    }
    
    var entryContent: DiaryEntryModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentDate == "" {
            currentDate = AppLogic.getDate()
        }
        setupView()
        let exitKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(exitKeyboard)
    }
    

    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func moodTracker(_ sender: UIButton) {
        switch sender.tag {
        case 1: mood = .happy
        case 2: mood = .neutral
        case 3: mood = .sad
        default: mood = .neutral
        }
        highlightSelectedMood(mood)
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if sender.title == "Edit" {
            sender.title = "Cancel"
            enableUI()
        } else {
            sender.title = "Edit"
            disableUI()
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
            
            FirebaseMethods.Database.writeToDatabase(currentDate, timeOfDay, mood.rawValue, userId, text1, text2, text3, text4, text5, text6, diaryText) { result in
                switch result {
                case .success():
                    self.present(Alerts.confirmationMessage("Diary entry saved!"), animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.dismiss(animated: true)
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error as NSError):
                    if let code = FirestoreErrorCode.Code(rawValue: error.code) {
                        self.present(Alerts.errorAlert(FirestoreErrors.presentError(using: code)), animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func expandDiaryEntry(_ sender: UIButton) {
        performSegue(withIdentifier: "showExpandedView", sender: self)
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
            
            highlightSelectedMood(Mood(rawValue: passedContent.mood!) ?? .neutral)
            
            title = AppLogic.convertAmPm(passedContent.timeOfDay!).title
            firstLabel.text = AppLogic.convertAmPm((passedContent.timeOfDay)!).firstHeader
            secondLabel.text = AppLogic.convertAmPm((passedContent.timeOfDay)!).secondHeader
            
            disableUI()
            expandButton.isHidden = false
            
            
        } else {
            title = screenTitle
            firstLabel.text = firstLabelText
            secondLabel.text = secondLabelText
            expandButton.isHidden = true
            for container in containerViews {
                container.backgroundColor = containerViewsBackgroundColor
            }
        }
        txtField1.delegate = self
        txtField2.delegate = self
        txtField3.delegate = self
        txtField4.delegate = self
        txtField5.delegate = self
        txtField6.delegate = self
        for container in containerViews {
            container.layer.cornerRadius = container.frame.width/35
        }
        diaryEntry.layer.cornerRadius = diaryEntry.frame.width/60
        
    }
    
    func highlightSelectedMood(_ mood: Mood) {
        if mood == .happy {
            enableButton(happyMoodButton)
            disableButton(neutralMoodButton)
            disableButton(sadMoodButton)
        } else if mood == .neutral {
            disableButton(happyMoodButton)
            enableButton(neutralMoodButton)
            disableButton(sadMoodButton)
        } else if mood == .sad {
            disableButton(happyMoodButton)
            disableButton(neutralMoodButton)
            enableButton(sadMoodButton)
        }
    }
    
    func enableButton(_ button: UIButton) {
        button.layer.borderColor = UIColor(named: "CustomPinkColor")?.cgColor
        button.layer.cornerRadius = happyMoodButton.frame.height/2
        button.layer.borderWidth = happyMoodButton.frame.height/8
        button.alpha = 1
    }
    
    func disableButton(_ button: UIButton) {
        button.layer.borderWidth = 0
        button.alpha = 0.4
    }
    
    func disableUI() {
        happyMoodButton.isUserInteractionEnabled = false
        neutralMoodButton.isUserInteractionEnabled = false
        sadMoodButton.isUserInteractionEnabled = false
        txtField1.isUserInteractionEnabled = false
        txtField2.isUserInteractionEnabled = false
        txtField3.isUserInteractionEnabled = false
        txtField4.isUserInteractionEnabled = false
        txtField5.isUserInteractionEnabled = false
        txtField6.isUserInteractionEnabled = false
        diaryEntry.isUserInteractionEnabled = false
        saveButton.isEnabled = false
        for view in containerViews {
            view.backgroundColor = containerViewsBackgroundColor.withAlphaComponent(0.7)
        }
    }
    
    func enableUI() {
        happyMoodButton.isUserInteractionEnabled = true
        neutralMoodButton.isUserInteractionEnabled = true
        sadMoodButton.isUserInteractionEnabled = true
        txtField1.isUserInteractionEnabled = true
        txtField2.isUserInteractionEnabled = true
        txtField3.isUserInteractionEnabled = true
        txtField4.isUserInteractionEnabled = true
        txtField5.isUserInteractionEnabled = true
        txtField6.isUserInteractionEnabled = true
        diaryEntry.isUserInteractionEnabled = true
        saveButton.isEnabled = true
        for view in containerViews {
            view.backgroundColor = containerViewsBackgroundColor
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showExpandedView" {
            if let destinationVC = segue.destination as? ExpandedViewController {
                destinationVC.delegate = self
                destinationVC.text = diaryEntry.text
                destinationVC.backgroundColor = containerViewsBackgroundColor
            }
        }
    }
}

extension DiaryEntryViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

extension DiaryEntryViewController: ExpandedViewControllerDelegate {
    func passDiaryText(_ text: String) {
        diaryEntry.text = text
        enableUI()
        saveButton.isEnabled = true
    }
}

