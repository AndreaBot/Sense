//
//  LaunchScreenViewController.swift
//  Sense
//
//  Created by Andrea Bottino on 18/11/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class LaunchScreenViewController: UIViewController {

    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    var quoteModel: QuoteModel? {
        didSet {
            DispatchQueue.main.async { [self] in
                quoteLabel.text = quoteModel?.quote
                authorLabel.text = quoteModel?.author
                quoteLabel.alpha = 1
                authorLabel.alpha = 1
                continueButton.alpha = 1
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        QuoteGenerator.delegate = self
        quoteLabel.alpha = 0
        authorLabel.alpha = 0
        continueButton.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            QuoteGenerator.performRequest()
        }
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "goToDiary", sender: self)
        } else {
            performSegue(withIdentifier: "goToUser", sender: self)
        }
    }
}


extension LaunchScreenViewController: QuotesGeneratorDelegate {
    func setQuoteModel(_ fetchedQuoteModel: QuoteModel) {
        quoteModel = fetchedQuoteModel
    }
    
    func didFailWithError(_ error: Error) {
        print("error: \(error)")
    }
    
    
    
    
}
