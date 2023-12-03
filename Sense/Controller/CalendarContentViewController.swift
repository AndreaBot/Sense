//
//  CalendarContentViewController.swift
//  Sense
//
//  Created by Andrea Bottino on 22/11/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth

protocol CalendarContentViewDelegate {
    func showDiaryEntryContent(_ buttonTitle: String)
}

class CalendarContentViewController: UIViewController {
    
    
    @IBOutlet weak var morningIntentionsButton: UIButton!
    @IBOutlet weak var eveningReflectionsButton: UIButton!
    
    var currentDate = ""
    var delegate: CalendarContentViewDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        morningIntentionsButton.isHidden = true
        eveningReflectionsButton.isHidden = true
        checkDatabase()
    }
    
    func checkDatabase() {
        if let userId = Auth.auth().currentUser?.uid {
            var isMorningButtonHidden = true
            var isEveningButtonHidden = true
            
            FirebaseMethods.Database.checkForDoc("am", currentDate, userId) { result in
                switch result {
                case .success:
                    self.morningIntentionsButton.isHidden = false
                    isMorningButtonHidden = false
                case .failure:
                    self.morningIntentionsButton.isHidden = true
                }
                
                FirebaseMethods.Database.checkForDoc("pm", self.currentDate, userId) { result in
                    switch result {
                    case .success:
                        self.eveningReflectionsButton.isHidden = false
                        isEveningButtonHidden = false
                    case .failure:
                        self.eveningReflectionsButton.isHidden = true
                    }
                    if isMorningButtonHidden && isEveningButtonHidden {
                        self.createNoDataLabel()
                    }
                }
            }
        }
    }

    func createNoDataLabel() {
        let label = UILabel()
        view.addSubview(label)
        label.text = "No diary entry for this date."
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @IBAction func diaryEntryPressed(_ sender: UIButton) {
        dismiss(animated: true)
        delegate?.showDiaryEntryContent(AppLogic.convertButtonTitleToDocName(sender.currentTitle!))
    }
}
