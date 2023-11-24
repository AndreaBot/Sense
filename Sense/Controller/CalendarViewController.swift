//
//  CalendarViewController.swift
//  Sense
//
//  Created by Andrea Bottino on 18/11/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FSCalendar

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
    
    var formattedDate = ""
    let db = Firestore.firestore()
    var entryContent: DiaryEntryModel?
    var timeOfDayToPass = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
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
}

extension CalendarViewController: FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let calendar = Calendar.current
        let day = String(calendar.component(.day, from: date))
        let month = String(calendar.component(.month, from: date))
        let year = String(calendar.component(.year, from: date))
        formattedDate = day+month+year
        
        performSegue(withIdentifier: "showCalendarContent", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCalendarContent" {
            
            let destinationVC = segue.destination as? CalendarContentViewController
            destinationVC?.delegate = self
            destinationVC?.currentDate = formattedDate
            
            if let sheet = destinationVC?.sheetPresentationController {
                sheet.detents = [.custom(resolver: { context in
                    return context.maximumDetentValue * 0.33
                })]
                sheet.preferredCornerRadius = 10
            }
            
        } else if segue.identifier == "showEntryContent" {
            let destinationVC = segue.destination as? DiaryEntryViewController
            destinationVC?.entryContent = entryContent
            destinationVC?.saveButton.isEnabled = false
            destinationVC?.timeOfDay = timeOfDayToPass
            destinationVC?.currentDate = formattedDate
        }
    }
}

extension CalendarViewController: CalendarContentViewDelegate {
    
    func showDiaryEntryContent(_ buttonTitle: String) {
        if let userId = Auth.auth().currentUser?.uid {
            
            let collectionRef = db.collection(userId).document(formattedDate).collection(formattedDate)
            let docRef = collectionRef.document(buttonTitle)
            
            docRef.getDocument(completion: { [self] (documentSnapshot, error) in
                if let error = error {
                    print("Error getting document: \(error)")
                    return
                }
                if let data = documentSnapshot?.data() {
                    
                    let timeOfDay = data["timeOfDay"]
                    let mood = data["mood"]
                    let text1 = data["txtField1"]
                    let text2 = data["txtField2"]
                    let text3 = data["txtField3"]
                    let text4 = data["txtField4"]
                    let text5 = data["txtField5"]
                    let text6 = data["txtField6"]
                    let diaryText = data["diaryEntry"]
                    
                    entryContent = DiaryEntryModel(
                        
                        timeOfDay: timeOfDay as? String,
                        mood: mood as? String,
                        txtField1: text1 as? String,
                        txtField2: text2 as? String,
                        txtField3: text3 as? String,
                        txtField4: text4 as? String,
                        txtField5: text5 as? String,
                        txtField6: text6 as? String,
                        diaryText: diaryText as? String)
                    
                    timeOfDayToPass = timeOfDay as! String
                    
                    performSegue(withIdentifier: "showEntryContent", sender: self)
                }
            })
        }
    }
}
