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
    @IBOutlet weak var quoteContainerView: UIView!
    
    
    var quoteModel: QuoteModel? {
        didSet {
            DispatchQueue.main.async { [self] in
                quoteLabel.text = "''\(quoteModel!.quote)''"
                authorLabel.text = quoteModel!.author
                UIView.transition(with: quoteContainerView, duration: 1, options: .transitionCrossDissolve, animations: {
                    self.quoteContainerView.alpha = 1
                }, completion: nil)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    UIView.transition(with: self.continueButton, duration: 1, options: .transitionCrossDissolve, animations: {
                        self.continueButton.alpha = 1
                    }, completion: nil)
                }
            }
        }
    }
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        QuoteGenerator.delegate = self
        quoteContainerView.layer.cornerRadius = quoteContainerView.frame.height/7
        quoteContainerView.backgroundColor = UIColor(white: 0.6, alpha: 0.2)
        quoteContainerView.alpha = 0
        continueButton.alpha = 0
        if let showAgainBool = defaults.object(forKey: "dontShowAgain") as? Bool {
            AppLogic.dontShowAgain = showAgainBool
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
