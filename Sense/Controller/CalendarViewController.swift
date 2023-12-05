//
//  CalendarViewController.swift
//  Sense
//
//  Created by Andrea Bottino on 18/11/2023.
//

import UIKit
import FirebaseAuth

class CalendarViewController: UIViewController {
    
    var formattedDate = ""
    var entryContent: DiaryEntryModel?
    var timeOfDayToPass = ""
    var dates = [String]()
    var components = [DateComponents]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCalendar()
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
    
    func createCalendar() {
        let calendarView = UICalendarView()
        view.addSubview(calendarView)
        calendarView.center = view.center
        let calendarWidth: CGFloat = view.frame.width * 0.9
        let calendarHeight: CGFloat = view.frame.height * 0.8
        
        calendarView.frame = CGRect(x: view.center.x - (calendarWidth / 2),
                                    y: view.center.y - (calendarHeight / 2),
                                    width: calendarWidth,
                                    height: calendarHeight)
        
        calendarView.calendar = .current
        calendarView.locale = Locale(identifier: "en_GB")
        calendarView.delegate = self
        calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
        calendarView.availableDateRange = DateInterval(start: .distantPast, end: .now)
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

extension CalendarViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        if let component = dateComponents {
            let day = String(component.day!)
            let month = String(component.month!)
            let year = String(component.year!)
            formattedDate = day+month+year
            performSegue(withIdentifier: "showCalendarContent", sender: self)
        }
    }
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if let userId = Auth.auth().currentUser?.uid {
            let day = String(dateComponents.day!)
            let month = String(dateComponents.month!)
            let year = String(dateComponents.year!)
            let oneDate = day + month + year
            
            FirebaseMethods.Database.getDaysWithEvents(userId, oneDate) { result in
                switch result {
                case .success(let date):
                    if !self.dates.contains(date) {
                        self.dates.append(date)
                        self.components.append(dateComponents)
                        
                        DispatchQueue.main.async {
                            calendarView.reloadDecorations(forDateComponents: self.components, animated: true)
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
            
            for d in dates {
                if oneDate == d {
                    return UICalendarView.Decoration.default(color: .systemGreen, size: .medium)
                }
            }
        }
        return nil
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



