//
//  CalendarViewController.swift
//  Sense
//
//  Created by Andrea Bottino on 18/11/2023.
//

import UIKit
import FirebaseAuth
import FSCalendar

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
    
    var formattedDate = ""
    var entryContent: DiaryEntryModel?
    var timeOfDayToPass = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
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
            
            FirebaseMethods.Database.getDoc(userId, formattedDate, buttonTitle) { [self] entry in
                if let entry = entry {
                    entryContent = entry
                    timeOfDayToPass = entry.timeOfDay!
                    performSegue(withIdentifier: "showEntryContent", sender: self)
                } else {
                    print("Entry not found or error occurred.")
                }
            }
        }
    }
}
