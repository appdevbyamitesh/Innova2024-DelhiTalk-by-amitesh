//
//  LoginViewController.swift
//  InnovaEventManagement
//
//  Created by Amitesh Mani Tiwari on 30/11/24.
//

import UIKit

class LoginViewController: UIViewController {
    private let viewModel = AuthViewModel()
    private let containerView = UIView()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let registerButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController loaded")
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "Welcome to InnovaEvent Management"

        // Container View
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        // Email Field
        emailField.placeholder = "Email"
        emailField.borderStyle = .roundedRect
        emailField.leftView = UIImageView(image: UIImage(systemName: "envelope"))
        emailField.leftViewMode = .always
        emailField.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(emailField)

        // Password Field
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        passwordField.borderStyle = .roundedRect
        passwordField.leftView = UIImageView(image: UIImage(systemName: "lock"))
        passwordField.leftViewMode = .always
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(passwordField)

        // Login Button
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 8
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(loginButton)

        // Register Button
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.systemBlue, for: .normal)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(registerButton)

        // Layout Constraints
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

            emailField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            emailField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            passwordField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            loginButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7),
            loginButton.heightAnchor.constraint(equalToConstant: 50),

            containerView.bottomAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),

            registerButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func loginTapped() {
        guard let email = emailField.text, let password = passwordField.text else { return }
        viewModel.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                let eventListVC = EventListViewController()
                self?.navigationController?.pushViewController(eventListVC, animated: true)
            case .failure(let error):
                self?.showErrorAlert(message: error.localizedDescription)
            }
        }
    }

    @objc private func registerTapped() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
