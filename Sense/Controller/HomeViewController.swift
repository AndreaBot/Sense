//
//  HomeViewController.swift
//  Sense
//
//  Created by Andrea Bottino on 18/11/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesBackButton = true
    }
    
    func setButtons() {
        registerButton.layer.cornerRadius = registerButton.frame.height/7
        registerButton.layer.borderWidth = registerButton.frame.height/18
        registerButton.layer.borderColor = UIColor(named: "CustomPinkColor")?.cgColor
        loginButton.layer.cornerRadius = loginButton.frame.height/7
    }
}
