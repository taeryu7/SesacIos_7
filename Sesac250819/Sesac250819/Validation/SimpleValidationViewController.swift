//
//  SimpleValidationViewController.swift
//  Sesac250819
//
//  Created by 유태호 on 8/19/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5

class SimpleValidationViewController: UIViewController {

    let usernameLabel = UILabel()
    let usernameTextField = UITextField()
    let usernameValidLabel = UILabel()
    
    let passwordLabel = UILabel()
    let passwordTextField = UITextField()
    let passwordValidLabel = UILabel()
    
    let doSomethingButton = UIButton()
    
    private let viewModel = SimpleValidationViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Simple validation"
        
        configureLayout()
        configure()
        bindViewModel()
    }
    
    @objc func dismissViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    private func bindViewModel() {
        let input = SimpleValidationViewModel.Input(
            usernameText: usernameTextField.rx.text.orEmpty.asObservable(),
            passwordText: passwordTextField.rx.text.orEmpty.asObservable(),
            buttonTap: doSomethingButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        // UI 바인딩
        output.passwordEnabled
            .drive(passwordTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.usernameErrorHidden
            .drive(usernameValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.passwordErrorHidden
            .drive(passwordValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.buttonEnabled
            .drive(doSomethingButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.showAlert
            .drive(with: self) { owner, _ in
                owner.showAlert()
            }
            .disposed(by: disposeBag)
    }

    func configure() {
        usernameLabel.text = "Username"
        usernameLabel.font = .systemFont(ofSize: 17)
        usernameLabel.textColor = .label
        
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.font = .systemFont(ofSize: 14)
        
        usernameValidLabel.text = "Username has to be at least \(minimalUsernameLength) characters"
        usernameValidLabel.font = .systemFont(ofSize: 17)
        usernameValidLabel.textColor = .systemRed
        
        passwordLabel.text = "Password"
        passwordLabel.font = .systemFont(ofSize: 17)
        passwordLabel.textColor = .label
        
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.font = .systemFont(ofSize: 14)
        passwordTextField.isSecureTextEntry = true
        
        passwordValidLabel.text = "Password has to be at least \(minimalPasswordLength) characters"
        passwordValidLabel.font = .systemFont(ofSize: 17)
        passwordValidLabel.textColor = .systemRed
        
        doSomethingButton.setTitle("Do something", for: .normal)
        doSomethingButton.setTitleColor(.black, for: .normal)
        doSomethingButton.setTitleColor(.systemGray3, for: .disabled)
        doSomethingButton.backgroundColor = UIColor(red: 0.458, green: 1.0, blue: 0.506, alpha: 1.0)
    }
    
    func configureLayout() {
        [usernameLabel, usernameTextField, usernameValidLabel,
         passwordLabel, passwordTextField, passwordValidLabel,
         doSomethingButton].forEach {
            view.addSubview($0)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(26)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(30)
        }
        
        usernameValidLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameValidLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(30)
        }
        
        passwordValidLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        doSomethingButton.snp.makeConstraints { make in
            make.top.equalTo(passwordValidLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "RxExample",
            message: "This is wonderful",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
