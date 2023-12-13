//
//  Notifications.swift
//  Sense
//
//  Created by Andrea Bottino on 13/12/2023.
//

import UIKit
import UserNotifications

struct Notifications {
    
    static func askForPermission(_ vc: UIViewController) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: .alert) { accepted, error in
            if !accepted {
                DispatchQueue.main.async{
                    vc.present(Alerts.notificationsAlert("Sense", "You can set up reminder notifications in your settings"), animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    vc.performSegue(withIdentifier: "setNotificationsMenu", sender: self)
                }
            }
        }
        
        //        let content = UNMutableNotificationContent()
        //        content.title = "Title"
        //        content.body = "Body"
        //
        //        let date = Date().addingTimeInterval(10)
        //        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        //
        //        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        //
        //       let uuidString = UUID().uuidString
        //       let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        //
        //       center.add(request)

    }
}
