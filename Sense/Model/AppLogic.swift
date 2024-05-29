//
//  AppLogic.swift
//  Sense
//
//  Created by Andrea Bottino on 26/11/2023.
//

import UIKit

struct AppLogic {
    
    static func getDate() -> String {
        let date = Date()
        let calendar = Calendar.current
        let day = String(calendar.component(.day, from: date))
        let month = String(calendar.component(.month, from: date))
        let year = String(calendar.component(.year, from: date))
        return day+month+year
    }
    
    static func convertAmPm(_ timeOfDay: String) -> (title: String, firstHeader: String, secondHeader: String, backgroundColor: UIColor) {
        var title = ""
        var firstHeader = ""
        var secondHeader = ""
        var backgroundColor = UIColor()
        if timeOfDay == "am" {
            title = "Daily Intentions"
            firstHeader = "Today's positive intentions"
            secondHeader = "Top 3 To-Do's"
            backgroundColor = UIColor(named: "CustomOrangeColor")!
        } else {
            title = "Evening Reflections"
            firstHeader = "Three things I did well today"
            secondHeader = "Three thing I could improve on"
            backgroundColor = UIColor(named: "CustomBlueColor")!
        }
        return (title, firstHeader, secondHeader, backgroundColor)
    }
    
    static func convertButtonTitleToDocName(_ buttonTitle: String) -> String {
        if buttonTitle == "Daily Intentions" {
            return "am"
        } else {
            return "pm"
        }
    }
    
    static func enableAmBasedOnTime(_ morningButton: UIButton) {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        morningButton.isEnabled = hour > 12 ? false : true
    }
    
    static func enablePmBasedOnTime(_ eveningButton: UIButton) {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        eveningButton.isEnabled = hour > 12 ? true : false
    }
    
    static func resetVC(_ vc: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let targetViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        let navigationController = UINavigationController(rootViewController: targetViewController)
        navigationController.modalPresentationStyle = .fullScreen
        vc.present(navigationController, animated: true, completion: nil)
    }
}
