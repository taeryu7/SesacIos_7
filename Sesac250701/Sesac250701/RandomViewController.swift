//
//  RandomViewController.swift
//  Sesac250701
//
//  Created by 유태호 on 7/1/25.
//

import UIKit

class RandomViewController: UIViewController {

    @IBOutlet var resultLable: UILabel!
    
    @IBOutlet var randomButton: UIButton!
    
    @IBOutlet var userTextField: UITextField!
    
    var nickname = "mac"
    
    
    /// 사용자 눈에 보이기 직전에 실행되는 기능
    /// 모서리 둥글기, 그림자 등 속성을 미리 설정할 떄 사용
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        LableUI()
        ButtonUI()
        TextFieldUI()
    }
    
    private func LableUI() {
        resultLable.backgroundColor = UIColor.orange
        resultLable.textColor = UIColor.black
        resultLable.text = "ㅎㅇㄹ"
        resultLable.numberOfLines = 2
        resultLable.font = UIFont.systemFont(ofSize: 20)
        resultLable.textAlignment = NSTextAlignment.center
        resultLable.alpha = 0.8
        resultLable.layer.cornerRadius = 10
        resultLable.clipsToBounds = true
        resultLable.layer.borderColor = UIColor.black.cgColor
    }
    
    private func ButtonUI() {
        randomButton.setTitle( "랜덤", for: .normal)
        randomButton.setTitleColor( UIColor.black, for: .normal)
        randomButton.setTitle( "랜덤으로 바뀜", for: .highlighted)
        randomButton.setTitleColor( UIColor.gray, for: .highlighted)
        randomButton.backgroundColor = UIColor.green
        randomButton.layer.cornerRadius = 30
        randomButton.layer.borderColor = UIColor.black.cgColor
    }
    
    private func TextFieldUI() {
        userTextField.placeholder = "사용자 이름"
        userTextField.keyboardType = .emailAddress
        userTextField.borderStyle = .bezel
        userTextField.isSecureTextEntry = true
    }
    
    
    /// touch up inside
    @IBAction func ButtonTapped(_ sender: UIButton) {
        print("button tapped")
        resultLable.text = "ㅎㅇㅎㅇ \(Int.random(in: 1...999))"
    }
    
    @IBAction func userTextFieldChange(_ sender: UITextField) {
        print("이게뭐고")
        print(userTextField.text)
    }
    
    /// 키보드에서 return 키를 누르면 키보드가 내려감
    @IBAction func textFieldEndExit(_ sender: UITextField) {
        print("what is this")
    }
    
}
