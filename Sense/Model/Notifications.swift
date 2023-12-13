//
//  Notifications.swift
//  Sense
//
//  Created by Andrea Bottino on 13/12/2023.
//

import UIKit
import UserNotifications

struct Notifications {
    
    static let center = UNUserNotificationCenter.current()
    
    static func askForPermission(_ vc: UIViewController) {
        
        center.requestAuthorization(options: .alert) { accepted, error in
            if !accepted {
                DispatchQueue.main.async{
                    vc.present(Alerts.notificationsAlert("Sense", "You can set up reminder notifications in your settings"), animated: true)
                }
            } else if AppLogic.notificationsAlreadySet == false {
                DispatchQueue.main.async {
                    vc.performSegue(withIdentifier: "setNotificationsMenu", sender: self)
                }
            }
        }
    }
    
    static func setAmReminderTime(_ time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Sense"
        content.body = "It's time for your morning session!"
        let components = Calendar.current.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    static func setPmReminderTime(_ time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Sense"
        content.body = "It's time for your evening session!"
        let components = Calendar.current.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        center.add(request)
    }
}
