//
//  Notifications.swift
//  Sense
//
//  Created by Andrea Bottino on 13/12/2023.
//

import UIKit
import UserNotifications

struct Notifications {
    
    static let defaults = UserDefaults.standard
    static var dontShowAgain = Bool()
    static var notificationsAlreadySet = Bool()
    static var amTime = Date()
    static var pmTime = Date()
    static let center = UNUserNotificationCenter.current()
    static let amMessages = ["It's time for your morning session!",
                             "Rise, shine and open Sense!",
                             "Start the day right with Sense!",
                             "New day, get planning on Sense!",
                             "Don't be late, it's Sense-time!"]
    static var pmMessages = ["It's time for your evening session!",
                              "What a day, get it to make sense on... Sense!",
                              "How has today treated you?",
                              "Every day is a school day, what has life taught you today?",
                              "The key to change is daily practice, finish the day on Sense!"]
    
    static func askForPermission(_ vc: UIViewController) {
        center.requestAuthorization(options: .alert) { accepted, error in
            if !accepted {
                DispatchQueue.main.async{
                    vc.present(Alerts.notificationsAlert("Sense", "You can set up reminder notifications in your settings"), animated: true)
                }
            } else if Notifications.notificationsAlreadySet == false {
                DispatchQueue.main.async {
                    vc.performSegue(withIdentifier: "setNotificationsMenu", sender: self)
                }
            }
        }
    }
    
    static func setAmReminderTime(_ time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Sense"
        content.body = amMessages.randomElement()!
        let components = Calendar.current.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    static func setPmReminderTime(_ time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Sense"
        content.body = pmMessages.randomElement()!
        let components = Calendar.current.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        center.add(request)
    }

    
    static func updateShowAgainUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(Notifications.dontShowAgain, forKey: "dontShowAgain")
    }
    
    static func updateAlreadySetUserDefaults() {
        defaults.set(Notifications.notificationsAlreadySet, forKey: "notificationsAlreadySet")
    }
    
    static func updateDefaultTimes() {
        defaults.set(Notifications.amTime, forKey: "amTime")
        defaults.set(Notifications.pmTime, forKey: "pmTime")
    }
    
    static func setAvailableTimes(_ datePicker: UIDatePicker, _ minH: Int, _ maxH: Int, _ maxM: Int) {
        let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        let minDate = Calendar.current.date(bySettingHour: minH, minute: 0, second: 0, of: date!)
        let maxDate = Calendar.current.date(bySettingHour: maxH, minute: maxM, second: 0, of: date!)
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
    }
    
    static func setDefaultTime(userDefaultKey: String) -> Date? {
        if let time = defaults.object(forKey: userDefaultKey) {
            return time as? Date
        } else {
            return nil
        }
    }
}
