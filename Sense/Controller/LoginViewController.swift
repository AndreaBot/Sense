//
//  LoginViewController.swift
//  Sense
//
//  Created by Andrea Bottino on 18/11/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class LoginViewController: UIViewController {


    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let showPasswordButton = UIButton()
    let eyeImage = UIImage(systemName: "eye")
    let eyeSlashImage = UIImage(systemName: "eye.slash")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        title = "Login"
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        navigationItem.hidesBackButton = false
        setShowPasswordButton()
        
        let customRightView = UIView(frame: CGRect(x: 0, y: 0, width: passwordTextField.frame.width/8, height: passwordTextField.frame.height))
        customRightView.addSubview(showPasswordButton)
        
        passwordTextField.rightView = customRightView
        passwordTextField.rightViewMode = .always
   
        loginButton.layer.cornerRadius = loginButton.frame.height/7
    }
    
    
    @IBAction func loginUser(_ sender: UIButton) {
        
        if let userEmail = emailTextField.text, let userPassword = passwordTextField.text {
            
            FirebaseMethods.Authentication.login(userEmail, userPassword) { result in
                switch result {
                case .success:
                    self.performSegue(withIdentifier: "login", sender: self)
                case .failure(let error):
                    self.present(Alerts.errorAlert(error.localizedDescription), animated: true)
                }
            }
        }
    }
    
    func setShowPasswordButton() {
        showPasswordButton.frame = CGRect(x: 0, y: 0, width: passwordTextField.frame.width/8, height: passwordTextField.frame.height)
        showPasswordButton.setImage(eyeSlashImage, for: .normal)
        showPasswordButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        showPasswordButton.tintColor = .label
    }
    
    @objc func showPassword() {
        if passwordTextField.isSecureTextEntry == true {
            passwordTextField.isSecureTextEntry = false
            showPasswordButton.setImage(eyeImage, for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            showPasswordButton.setImage(eyeSlashImage, for: .normal)
        }
    }
}
