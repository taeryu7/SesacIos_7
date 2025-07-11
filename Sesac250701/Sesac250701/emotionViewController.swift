//
//  emotionViewController.swift
//  Sesac250701
//
//  Created by 유태호 on 7/2/25.
//

import UIKit

class emotionViewController: UIViewController {
    
    /// outlet collection = 배열로 처리(여러개의 객체를 연결
    @IBOutlet var emotionLabel: [UILabel]!
    
    @IBOutlet var firstTextField: UITextField!
    @IBOutlet var secondTextField: UITextField!
    @IBOutlet var thirdTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        /// ()함수호출 연산자
        /// parameter : 아무리 많이 함수를 호출하더라도 달라지지 않는 주머니이름(매개변수)
        /// arguments : 매번 다른 값들이 들어가는 부분 (전달인자)
        designTextField(tf: firstTextField, ph: "firstTextField", isst: false)
        designTextField(tf: secondTextField, ph: "secondTextField", isst: true)
        designTextField(tf: thirdTextField, ph: "thirdTextField",
                        isst: false)
    }
    
    private func setUI() {
        
        for item in emotionLabel {
            item.textColor = .red
        }
        
        for item in 0...2 {
            emotionLabel[item].backgroundColor = .black
        }
    }

    
    
    /// 매개변수(parameter)
    /// 내부 매개변수 textfield : parameter NAme
    /// 외부 매개변수 tf : Arguments Label
    /// 와일드카드 식별자를 통해 외부 매개변수를 생략할 수 있다
    /// 매개변수에 대한 기본값
    private func designTextField(tf textField: UITextField, ph placeholder: String, isst : Bool = false) {
        textField.placeholder = placeholder
        textField.textColor = .black
        textField.keyboardType = .emailAddress
        textField.isSecureTextEntry = isst
        //textField.isSecureTextEntry = false
        textField.textAlignment = .center
    }
    
    /// swift overloading
    /// 이런식으로 같은 함수라도 다른방식으로 쓸수있음(따로 더 찾아볼것)
    func a() {
        
    }
    
    func a(b : String) {
        
    }

    @IBAction func firstTextFieldAction(_ sender: Any) {
        //printContent(textField: firstTextField)
        print(sender.self)
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        print("tapped")
        print(#function)
        
        
        /// 키보드를 내리는 기능
        view.endEditing(true)
    }
    
    
}
