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
        setReminderButton.isEnabled = false
        amStackView.backgroundColor = UIColor(named: "CustomOrangeColor")
        amStackView.layer.cornerRadius = amStackView.frame.width/30
        pmStackView.backgroundColor = UIColor(named: "CustomBlueColor")
        pmStackView.layer.cornerRadius = pmStackView.frame.width/30
        if let am = Notifications.setDefaultAmTime(),
           let pm = Notifications.setDefaultPmTime() {
                selectedAmTime = am
                selectedPmTime = pm
            }
        Notifications.setAvailableTimes(amTimePicker, 0, 11, 59)
        Notifications.setAvailableTimes(pmTimePicker, 12, 23, 59)
    }

    func resetVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let targetViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        let navigationController = UINavigationController(rootViewController: targetViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}
