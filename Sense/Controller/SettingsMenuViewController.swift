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
    
    var selectedAmTime = Date() {
        didSet {
            setReminderButton.isEnabled = true
        }
    }
    var selectedPmTime = Date() {
        didSet {
            setReminderButton.isEnabled = true
        }
    }
    
    var notificationsEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setReminderButton.isEnabled = false
        setAvailableTimes(amTimePicker, 0, 11, 59)
        setAvailableTimes(pmTimePicker, 12, 23, 59)
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        FirebaseMethods.Authentication.logout { result in
            switch result {
            case .success(): self.resetVC()
            case .failure(let error): self.present(Alerts.errorAlert(error.localizedDescription), animated: true)
            }
        }
    }
    
    @IBAction func openAppSettings(_ sender: UIButton) {
        if let aString = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(aString, options: [:])
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
    
    func setAvailableTimes(_ datePicker: UIDatePicker, _ minH: Int, _ maxH: Int, _ maxM: Int) {
        let minDate = Calendar.current.date(bySettingHour: minH, minute: 0, second: 0, of: Date())
        let maxDate = Calendar.current.date(bySettingHour: maxH, minute: maxM, second: 0, of: Date())
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
    }
    
    func resetVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let targetViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        let navigationController = UINavigationController(rootViewController: targetViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}
