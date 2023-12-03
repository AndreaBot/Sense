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
    
    static func convertTitleText(_ timeofDay: String) -> String {
        if timeofDay == "am" {
            return "Daily Intentions"
        } else {
            return "Evening Reflections"
        }
    }
    
    static func convertFirstLabelText(_ timeofDay: String) -> String {
        if timeofDay == "am" {
            return "Today's positive intentions"
        } else {
            return "Three things I did well today"
        }
    }
    
    static func convertSecondLabelText(_ timeofDay: String) -> String {
        if timeofDay == "am" {
            return "Top 3 To-Do's"
        } else {
            return "Three thing I could improve on"
        }
    }
    
    static func convertButtonTitleToDocName(_ buttonTitle: String) -> String {
        if buttonTitle == "Morning Intentions" {
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
}
