//
//  RandomViewController.swift
//  sesac20250703
//
//  Created by 유태호 on 7/7/25.
//

import UIKit

class RandomViewController: UIViewController {
    
    
    @IBOutlet var RandomButton: UIButton!
    @IBOutlet var RandomLabel: UILabel!
    @IBOutlet var redButton: UIButton!
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var checkButton: UIButton!
    
    @IBOutlet var alertButton: UIButton!
    
    
    
    //let list: [String] = ["김씨", "나씨", "박씨", "이씨", "최씨", "조씨", "정씨", "강씨", "서씨", "이씨"]
    let sender: [String] = ["김씨", "나씨", "박씨", "이씨", "최씨", "조씨", "정씨", "강씨", "서씨", "이씨"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /// 버튼 코드가 적용 안되는경우
        /// 우리가 쓰는 대부분의 코드는 defualt스타일 기준임. 객체를 만들때 나오는 plain버튼과는 다름
        /// 스토리보드에서 버튼의 스타일을 변경해주는데 좋음(추후 plain다루는거는 따로 배울 예정)
        RandomButton.setTitle("바꾸기", for: .normal)
        
        randomButtonAction(RandomButton)
        randomButtonAction(RandomButton)
        
        /// 1. 왜 옵셔널이 필요한가
        /// 2. !
        //var age = "22"
        //let next = Int(age)! + 1
        //print(next)
        
        //var nick: String = "rhfoqkq"
        //nick = "123"
        //nick = nil
        
        phoneTextField.text = UserDefaults.standard.string(forKey: "Nick")
        
        print(UserDefaults.standard.bool(forKey: "then"))
        print(UserDefaults.standard.integer(forKey: "age"))
        print(UserDefaults.standard.string(forKey: "Nick"))
        
    }
    
    
    
    
    @IBAction func randomButtonAction(_ sender: UIButton) {
        
        // 1.
        let list: [String] = ["김씨", "나씨", "박씨", "이씨", "최씨", "조씨", "정씨", "강씨", "서씨", "이씨"]
        let result = self.sender.randomElement()
        RandomLabel.text = result
    }
    
    
    @IBAction func redButtonTapped(_ sender: UIButton) {
        let result = self.sender.randomElement()
        redLabel.text = result
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        let value = phoneTextField.text!
        
        if Int(value) == nil {
            print("숫자가 아님")
        } else {
            print("숫자임")
            RandomLabel.text = "\(Int(value)! )"
        }
        
    }
    
    @IBAction func alertButtonClicked(_ sender: UIButton) {
        //1.
        //let alert = UIAlertController(title: nil, message: nil, preferredStyle: //.actionSheet)
        //
        ////2.
        //let ok1 = UIAlertAction(title: "확인", style: .default)
        //let ok2 = UIAlertAction(title: "확인", style: .default)
        //let ok3 = UIAlertAction(title: "뭐냐", style: .destructive)
        //let ok4 = UIAlertAction(title: "취소", style: .cancel)
        //
        ////3. addAction 순서대로 부틈
        //alert.addAction(ok1)
        //alert.addAction(ok2)
        //alert.addAction(ok3)
        //alert.addAction(ok4)
        //
        ////4. 띄우기
        //present(alert, animated: true)
        
        /// 실제 앱 용량에 저장
        /// 앱 껏다 키더라도 유지
        UserDefaults.standard.set(phoneTextField.text!, forKey: "Nick")
        
        UserDefaults.standard.set(40, forKey: "age")
    }
    
    
}
