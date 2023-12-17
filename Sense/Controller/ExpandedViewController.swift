//
//  ExpandedViewController.swift
//  Sense
//
//  Created by Andrea Bottino on 17/12/2023.
//

import UIKit

protocol ExpandedViewControllerDelegate {
    func passDiaryText(_ text: String)
}

class ExpandedViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var diaryEntry: UITextView!
    
    var delegate: ExpandedViewControllerDelegate?
    var text = ""
    var newText = ""
    var backgroundColor = UIColor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        newText = diaryEntry.text
        if newText != text {
            delegate?.passDiaryText(diaryEntry.text)
        }
        dismiss(animated: true)
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        if sender.currentTitle == "Edit" {
            sender.setTitle("Cancel", for: .normal)
            diaryEntry.isUserInteractionEnabled = true
            diaryEntry.becomeFirstResponder()
            containerView.backgroundColor = backgroundColor.withAlphaComponent(1)
        } else {
            sender.setTitle("Edit", for: .normal)
            diaryEntry.isUserInteractionEnabled = false
            diaryEntry.resignFirstResponder()
            containerView.backgroundColor = backgroundColor.withAlphaComponent(0.5)
        }
    }
    
    func setupUI() {
        diaryEntry.isUserInteractionEnabled = false
        diaryEntry.text = text
        containerView.backgroundColor = backgroundColor.withAlphaComponent(0.5)
        containerView.layer.cornerRadius = containerView.frame.width/35
        diaryEntry.layer.cornerRadius = diaryEntry.frame.width/60
    }
}
