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
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.hidesBackButton = false
        setShowPasswordButton()
        
        passwordTextField.rightView = setPasswordReveal(for: passwordTextField, button: showPasswordButton)
        passwordTextField.rightViewMode = .always
   
        loginButton.layer.cornerRadius = loginButton.frame.height/7
    }
    
    func setPasswordReveal(for txtField: UITextField, button: UIButton) -> UIView {
        let width = txtField.frame.width/8
        let height = txtField.frame.height
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        button.frame = frame
        button.setImage(eyeSlashImage, for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        let showPasswordContainer = UIView(frame: frame)
        showPasswordContainer.addSubview(button)
        return showPasswordContainer
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
