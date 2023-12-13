//
//  NotificationMenuViewController.swift
//  Sense
//
//  Created by Andrea Bottino on 13/12/2023.
//

import UIKit

class NotificationMenuViewController: UIViewController {
    
    @IBOutlet weak var amTimePicker: UIDatePicker!
    @IBOutlet weak var pmTimePicker: UIDatePicker!
    @IBOutlet weak var setReminderButton: UIButton!
    
    var selectedAmTime = Date() {
        didSet {
            setReminderButton.isEnabled = true
        }
    }
    var selectedPmTime = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setReminderButton.isEnabled = false
    }
    
    
    @IBAction func timePicked(_ sender: UIDatePicker) {
        if sender.tag == 1 {
            selectedAmTime = amTimePicker.date
        } else if sender.tag == 2 {
            selectedPmTime = pmTimePicker.date
        }
    }
    
    @IBAction func setReminderPressed(_ sender: UIButton) {
        Notifications.setAmReminderTime(selectedAmTime)
        Notifications.setPmReminderTime(selectedPmTime)
        AppLogic.notificationsAlreadySet = true
        AppLogic.updateAlreadySetUserDefaults()
        present(Alerts.confirmationMessage("Reminders set"), animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.dismiss(animated: true)
            self.dismiss(animated: true)
        }
    }
    
}
