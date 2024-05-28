//
//  NotificationMenuViewController.swift
//  Sense
//
//  Created by Andrea Bottino on 13/12/2023.
//

import UIKit

class SettingsMenuViewController: UIViewController {
    
    
    @IBOutlet weak var amTimePicker: UIDatePicker!
    @IBOutlet weak var pmTimePicker: UIDatePicker!
    @IBOutlet weak var setReminderButton: UIButton!
    @IBOutlet weak var amStackView: UIStackView!
    @IBOutlet weak var pmStackView: UIStackView!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    var selectedAmTime = Date() {
        didSet {
            setReminderButton.isEnabled = true
            Notifications.amTime = selectedAmTime
            amTimePicker.date = selectedAmTime
        }
    }
    var selectedPmTime = Date() {
        didSet {
            setReminderButton.isEnabled = true
            Notifications.pmTime = selectedPmTime
            pmTimePicker.date = selectedPmTime
        }
    }
    
    var calendar = Calendar.current
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func deleteAccountPressed(_ sender: UIButton) {
        present(Alerts.confirmationAlert(self), animated: true)
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        FirebaseMethods.Authentication.logout { result in
            switch result {
            case .success(): AppLogic.resetVC(self)
            case .failure(let error): self.present(Alerts.errorAlert(error.localizedDescription), animated: true)
            }
        }
    }
    
    @IBAction func openAppSettings(_ sender: UIButton) {
        if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettingsURL)
        }
    }
    
    @IBAction func timePicked(_ sender: UIDatePicker) {
        if sender.tag == 1 {
            selectedAmTime = amTimePicker.date
        } else if sender.tag == 2 {
            selectedPmTime = pmTimePicker.date
        }
    }
    
    @IBAction func setReminderPressed(_ sender: UIButton) {
        Notifications.center.removeAllPendingNotificationRequests()
    
        Notifications.setReminder(selectedAmTime, messageArray: Notifications.amMessages)
        Notifications.setReminder(selectedPmTime, messageArray: Notifications.pmMessages)
        
        Notifications.notificationsAlreadySet = true
        Notifications.updateAlreadySetUserDefaults()
        Notifications.updateDefaultTimes()
        present(Alerts.confirmationMessage("Reminders set"), animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.dismiss(animated: true)
            self.dismiss(animated: true)
        }
    }
    
    func setupUI() {
        customiseButton(deleteAccountButton)
        customiseButton(logoutButton)
        setReminderButton.isEnabled = false
        amStackView.backgroundColor = UIColor(named: "CustomOrangeColor")
        amStackView.layer.cornerRadius = amStackView.frame.width/30
        pmStackView.backgroundColor = UIColor(named: "CustomBlueColor")
        pmStackView.layer.cornerRadius = pmStackView.frame.width/30
        if let am = Notifications.setDefaultTime(userDefaultKey: "amTime"),
           let pm = Notifications.setDefaultTime(userDefaultKey: "pmTime") {
            selectedAmTime = am
            selectedPmTime = pm
        }
       Notifications.setAvailableTimes(amTimePicker, 0, 11, 59)
       Notifications.setAvailableTimes(pmTimePicker, 12, 23, 59)
    }
    
    func customiseButton(_ button: UIButton) {
        button.tintColor = UIColor.systemGray6
        button.layer.cornerRadius = button.frame.height/4
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = button.frame.height/12
    }
}
