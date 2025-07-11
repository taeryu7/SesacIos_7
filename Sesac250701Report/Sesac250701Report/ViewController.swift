//
//  ViewController.swift
//  Sesac250701Report
//
//  Created by 유태호 on 7/1/25.
//

import UIKit

class ViewController: UIViewController {
    
    private let mainLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let nicknameTextField = UITextField()
    private let locationTextField = UITextField()
    private let promocodeTextField = UITextField()
    private let signUpButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        configureUI()
        setupConstraints()
    }
    
    private func configureUI() {
        // 메인 라벨 설정
        mainLabel.text = "NETFLIX"
        mainLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        mainLabel.textColor = .red
        mainLabel.textAlignment = .center
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 텍스트 필드 설정
        emailTextField.placeholder = "이메일주소 또는 전화번호"
        emailTextField.font = UIFont.systemFont(ofSize: 16)
        emailTextField.textAlignment = .center
        emailTextField.borderStyle = .roundedRect
        emailTextField.backgroundColor = .gray
        emailTextField.textColor = .white
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.returnKeyType = .done
        emailTextField.keyboardType = .emailAddress
        emailTextField.layer.cornerRadius = 10
        
        passwordTextField.placeholder = "비밀번호"
        passwordTextField.font = UIFont.systemFont(ofSize: 16)
        passwordTextField.textAlignment = .center
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.backgroundColor = .gray
        passwordTextField.textColor = .white
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.keyboardType = .numberPad
        passwordTextField.layer.cornerRadius = 10
        
        nicknameTextField.placeholder = "닉네임"
        nicknameTextField.font = UIFont.systemFont(ofSize: 16)
        nicknameTextField.textAlignment = .center
        nicknameTextField.borderStyle = .roundedRect
        nicknameTextField.backgroundColor = .gray
        nicknameTextField.textColor = .white
        nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        nicknameTextField.returnKeyType = .done
        nicknameTextField.keyboardType = .emailAddress
        nicknameTextField.layer.cornerRadius = 10
        
        locationTextField.placeholder = "지역"
        locationTextField.font = UIFont.systemFont(ofSize: 16)
        locationTextField.textAlignment = .center
        locationTextField.borderStyle = .roundedRect
        locationTextField.backgroundColor = .gray
        locationTextField.textColor = .white
        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        locationTextField.returnKeyType = .done
        locationTextField.keyboardType = .emailAddress
        locationTextField.layer.cornerRadius = 10
        
        promocodeTextField.placeholder = "추천 코드 입력"
        promocodeTextField.font = UIFont.systemFont(ofSize: 16)
        promocodeTextField.textAlignment = .center
        promocodeTextField.borderStyle = .roundedRect
        promocodeTextField.backgroundColor = .gray
        promocodeTextField.textColor = .white
        promocodeTextField.translatesAutoresizingMaskIntoConstraints = false
        promocodeTextField.returnKeyType = .done
        promocodeTextField.keyboardType = .emailAddress
        promocodeTextField.layer.cornerRadius = 10
        
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.layer.cornerRadius = 10
        signUpButton.backgroundColor = .white
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        
        
        view.addSubview(mainLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(nicknameTextField)
        view.addSubview(locationTextField)
        view.addSubview(promocodeTextField)
        view.addSubview(signUpButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -300),
            mainLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            mainLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            emailTextField.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 110),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            nicknameTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            nicknameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            locationTextField.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 20),
            locationTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            locationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            locationTextField.heightAnchor.constraint(equalToConstant: 44),
            
            promocodeTextField.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 20),
            promocodeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            promocodeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            promocodeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            promocodeTextField.heightAnchor.constraint(equalToConstant: 44),
            
            //signUpButton.topAnchor.constraint(equalTo: promocodeTextField.bottomAnchor, constant: 20),
            //signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            //signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            //signUpButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
}


// MARK: - Preview Provider
#Preview {
    ViewController()
}
