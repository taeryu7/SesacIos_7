//
//  SighUpViewController.swift
//  Sesac250701ReportTHR
//
//  Created by 유태호 on 7/1/25.
//

import UIKit

class SighUpViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var pwTextField: UITextField!
    
    @IBOutlet var nicknameTextField: UITextField!
    
    @IBOutlet var locationTextField: UITextField!
    
    @IBOutlet var promocodeTextField: UITextField!
    
    @IBOutlet var sighupButton: UIButton!
    
    @IBOutlet var switchControll: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        ButtonUI()
        emailTextFieldUI()
        pwTextFieldUI()
        nicknameTextFieldUI()
        locationTextFieldUI()
        promocodeTextFieldUI()
        switchControllUI()
    }
    
    private func emailTextFieldUI() {
        emailTextField.placeholder = "이메일 주소 또는 전화번호"
        emailTextField.textColor = .white
        emailTextField.keyboardType = .emailAddress
        emailTextField.isSecureTextEntry = false
        emailTextField.textAlignment = .center
        emailTextField.layer.cornerRadius = 5
    }
    
    private func pwTextFieldUI() {
        pwTextField.placeholder = "비밀번호"
        pwTextField.textColor = .white
        pwTextField.keyboardType = .numberPad
        pwTextField.isSecureTextEntry = true
        pwTextField.textAlignment = .center
        pwTextField.layer.cornerRadius = 5
    }
    
    private func nicknameTextFieldUI() {
        nicknameTextField.placeholder = "닉네임"
        nicknameTextField.textColor = .white
        nicknameTextField.keyboardType = .emailAddress
        nicknameTextField.isSecureTextEntry = false
        nicknameTextField.textAlignment = .center
        nicknameTextField.layer.cornerRadius = 5
    }
    
    private func locationTextFieldUI() {
        locationTextField.placeholder = "지역"
        locationTextField.textColor = .white
        locationTextField.keyboardType = .emailAddress
        locationTextField.isSecureTextEntry = false
        locationTextField.textAlignment = .center
        locationTextField.layer.cornerRadius = 5
    }
    
    private func promocodeTextFieldUI() {
        promocodeTextField.placeholder = "추천 코드 입력"
        promocodeTextField.textColor = .white
        promocodeTextField.keyboardType = .emailAddress
        promocodeTextField.isSecureTextEntry = false
        promocodeTextField.textAlignment = .center
        promocodeTextField.layer.cornerRadius = 5
    }
    
    
    private func ButtonUI() {
        sighupButton.setTitle( "회원가입", for: .normal)
        sighupButton.setTitleColor( UIColor.black, for: .normal)
        sighupButton.setTitle( "회원가입됨", for: .highlighted)
        sighupButton.setTitleColor( UIColor.gray, for: .highlighted)
        sighupButton.backgroundColor = UIColor.white
        sighupButton.layer.cornerRadius = 5
        sighupButton.layer.borderColor = UIColor.black.cgColor
    }
    
    private func switchControllUI() {
        switchControll.onTintColor = .red
    }
    
    @IBAction func emailTextViewAction(_ sender: Any) {
    }
    
    @IBAction func pwTextViewAction(_ sender: Any) {
    }
    @IBAction func nicknameTextViewAction(_ sender: Any) {
    }
    @IBAction func locationTextViewAction(_ sender: Any) {
    }
    @IBAction func promocodeTextViewAction(_ sender: Any) {
    }
    
    @IBAction func sighupButtonAction(_ sender: Any) {
        print("=== 모든 TextField 값 출력 ===")
        print("이메일: \(emailTextField.text ?? "없음")")
        print("비밀번호: \(pwTextField.text ?? "없음")")
        print("닉네임: \(nicknameTextField.text ?? "없음")")
        print("지역: \(locationTextField.text ?? "없음")")
        print("추천코드: \(promocodeTextField.text ?? "없음")")
        print("스위치 상태: \(switchControll.isOn ? "켜짐" : "꺼짐")")
        
        // 유효성 검증
        print("\n=== 유효성 검증 시작 ===")
        let isEmailValid = validateEmail()
        let isPasswordValid = validatePassword()
        let isNicknameValid = validateNickname()
        let isLocationValid = validateLocation()
        let isPromocodeValid = validatePromocode()
        
        // 결과
        if isEmailValid && isPasswordValid && isNicknameValid && isLocationValid && isPromocodeValid {
            print("\n최종 결과: 모든 유효성 검증 통과 - 회원가입 가능")
        } else {
            print("\n최종 결과: 유효성 검증 실패 - 입력을 확인해주세요")
        }
    }
    
    // MARK: - 유효성 검증 함수들

    private func validateEmail() -> Bool {
        guard let email = emailTextField.text, !email.isEmpty else {
            print("이메일: 빈 값")
            return false
        }
        
        // 이메일 형식 검증
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        if emailPredicate.evaluate(with: email) {
            print("이메일: \(email) - 유효함")
            return true
        } else {
            print("이메일: \(email) - 형식이 올바르지 않음")
            return false
        }
    }

    private func validatePassword() -> Bool {
        guard let password = pwTextField.text, !password.isEmpty else {
            print("비밀번호: 빈 값")
            return false
        }
        
        // 비밀번호 길이 검증 (최소 6자)
        if password.count >= 6 {
            print("비밀번호: 길이 \(password.count)자 - 유효함")
            return true
        } else {
            print("비밀번호: 길이 \(password.count)자 - 최소 6자 이상 입력해주세요")
            return false
        }
    }

    private func validateNickname() -> Bool {
        guard let nickname = nicknameTextField.text, !nickname.isEmpty else {
            print("닉네임: 빈 값")
            return false
        }
        
        // 닉네임 길이 검증 (2-10자)
        if nickname.count >= 2 && nickname.count <= 10 {
            print("닉네임: \(nickname) - 유효함")
            return true
        } else {
            print("닉네임: \(nickname) - 2-10자 사이로 입력해주세요")
            return false
        }
    }

    private func validateLocation() -> Bool {
        guard let location = locationTextField.text, !location.isEmpty else {
            print("지역: 빈 값")
            return false
        }
        
        // 지역명 길이 검증 (최소 2자)
        if location.count >= 2 {
            print("지역: \(location) - 유효함")
            return true
        } else {
            print("지역: \(location) - 최소 2자 이상 입력해주세요")
            return false
        }
    }

    private func validatePromocode() -> Bool {
        guard let promocode = promocodeTextField.text else {
            print("추천코드: nil 값")
            return false
        }
        
        // 추천코드는 선택사항 (빈 값 허용)
        if promocode.isEmpty {
            print("추천코드: 빈 값 (선택사항)")
            return true
        }
        
        // 추천코드가 있다면 형식 검증 (영문+숫자, 4-8자)
        let promocodeRegex = "^[A-Za-z0-9]{4,8}$"
        let promocodePredicate = NSPredicate(format:"SELF MATCHES %@", promocodeRegex)
        
        if promocodePredicate.evaluate(with: promocode) {
            print("추천코드: \(promocode) - 유효함")
            return true
        } else {
            print("추천코드: \(promocode) - 영문+숫자 4-8자로 입력해주세요")
            return false
        }
    }
    
}
