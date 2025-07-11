//
//  nicknameViewController.swift
//  Sesac250701
//
//  Created by 유태호 on 7/2/25.
//

import UIKit

class nicknameViewController: UIViewController {

    
    @IBOutlet var firstTextField: UITextField!
    
    @IBOutlet var FirstButton: UIButton!
    
    @IBOutlet var firstLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /// 1. 버튼클릭시 레이블에 "아무내용" 보여주기
    /// 2. 버튼 클릭시 레이블에 "텍스트필드에 입력한 내용 보여주기"
    ///
    
    var nickname1 = "호날두"
    var nickname2: String = "벤제마"
    var nickname3: String = String(describing: "베일")
    var nickname4: String = .init("모드리치")
    
    /// 1. 읽어올수 있는 프로퍼티, 쓸 수 있는 프로퍼티가 따로 나뉘어져있다
    /// 2. 옵셔널 타입인지 옵셔널 타입이 아닌지 확인해보기
    /// 3. 빈값이면 비어있어요라고 출력하기
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        /// 1. 공백대응은?? whitespace
        /// 2.== "" 보다는  isEmpty
        if firstTextField.text?.isEmpty == true {
            firstLabel.text = "비어있어요"
        } else {
            firstLabel.text = firstTextField.text
        }
        
        //print(#function, firstTextField.text) // get
        //firstTextField.text = "abc" // set
        //FirstButton.currentTitle
        //firstLabel.text = firstTextField.text
        // \() ==> 문자열 보간은 무조건 값이 있어야만 함
        //firstLabel.text = "\(firstTextField.text!)"
        

        
    }
    
    
}
