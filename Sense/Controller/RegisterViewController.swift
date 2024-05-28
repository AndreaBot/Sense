//
//  RegisterViewController.swift
//  Sense
//
//  Created by Andrea Bottino on 18/11/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    let showPasswordButton = UIButton()
    let showRepeatPasswordButton = UIButton()
    let eyeImage = UIImage(systemName: "eye")
    let eyeSlashImage = UIImage(systemName: "eye.slash")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        title = "Register"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.hidesBackButton = false
        
        registerButton.layer.cornerRadius = registerButton.frame.height/7
        
        passwordTextField.rightView = setPasswordReveal(for: passwordTextField, button: showPasswordButton)
        passwordTextField.rightViewMode = .always
        
        repeatPasswordTextField.rightView = setPasswordReveal(for: repeatPasswordTextField, button: showRepeatPasswordButton)
        repeatPasswordTextField.rightViewMode = .always
    }
    
    func setPasswordReveal(for txtField: UITextField, button: UIButton) -> UIView {
        let width = txtField.frame.width/8
        let height = txtField.frame.height
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        button.frame = frame
        button.setImage(eyeSlashImage, for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(showPasswords), for: .touchUpInside)
        let showPasswordContainer = UIView(frame: frame)
        showPasswordContainer.addSubview(button)
        return showPasswordContainer
    }
    
    @objc func showPasswords() {
        if passwordTextField.isSecureTextEntry == true {
            passwordTextField.isSecureTextEntry = false
            repeatPasswordTextField.isSecureTextEntry = false
            showPasswordButton.setImage(eyeImage, for: .normal)
            showRepeatPasswordButton.setImage(eyeImage, for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            repeatPasswordTextField.isSecureTextEntry = true
            showPasswordButton.setImage(eyeSlashImage, for: .normal)
            showRepeatPasswordButton.setImage(eyeSlashImage, for: .normal)
        }
    }
    
    @IBAction func registerUser(_ sender: UIButton) {
        guard passwordTextField.text == repeatPasswordTextField.text else {
            present(Alerts.errorAlert("The passwords do not match. Please check the spelling"), animated: true)
            return
        }
        
        if let userEmail = emailTextField.text, let userPassword = passwordTextField.text {
            FirebaseMethods.Authentication.register(userEmail, userPassword) { result in
                switch result {
                case .success:
                    self.performSegue(withIdentifier: "register", sender: self)
                case .failure(let error):
                    self.present(Alerts.errorAlert(error.localizedDescription), animated: true)
                }
            }
        }
    }
}

