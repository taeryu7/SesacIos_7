//
//  BMICaculatorViewController.swift
//  SeSAC7Week1Remind
//
//  Created by 유태호 on 7/4/25.
//

import UIKit

class BMICaculatorViewController: UIViewController {
    
    @IBOutlet var StatureTextField: UITextField!
    
    @IBOutlet var WeightTextField: UITextField!
    
    @IBOutlet var BMIResultLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BMIResultLabel.isHidden = true
    }
    
    
    
    
    @IBAction func RandomBMIButton(_ sender: UIButton) {
        let randomStature = Int.random(in: 140...200)
        
        let randomWeight = Int.random(in: 40...120)
        
        StatureTextField.text = String(randomStature)
        WeightTextField.text = String(randomWeight)
        
        BMIResultLabel.isHidden = true
    }
    
    @IBAction func BMIResultButton(_ sender: UIButton) {
        
        guard let statureText = StatureTextField.text, !statureText.isEmpty,
               let weightText = WeightTextField.text, !weightText.isEmpty else {
             
             showAlert(title: "입력 오류", message: "키와 몸무게를 모두 입력해주세요.")
             return
         }
         
         guard let stature = Double(statureText),
               let weight = Double(weightText) else {
             
             // 숫자가 아닌 값이 입력된 경우
             showAlert(title: "입력 오류", message: "키와 몸무게는 숫자로 입력해주세요.")
             return
         }
         
         guard stature >= 100 && stature <= 250 else {
             showAlert(title: "범위 오류", message: "키는 100cm ~ 250cm 사이의 값을 입력해주세요.")
             return
         }
         
         guard weight >= 20 && weight <= 300 else {
             showAlert(title: "범위 오류", message: "몸무게는 20kg ~ 300kg 사이의 값을 입력해주세요.")
             return
         }
         
         let statureInMeters = stature / 100
         let bmi = weight / (statureInMeters * statureInMeters)
         
         BMIResultLabel.text = String(format: "BMI: %.2f", bmi)
         BMIResultLabel.isHidden = false
         
         view.endEditing(true)
     }

     func showAlert(title: String, message: String) {
         let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
         let okAction = UIAlertAction(title: "확인", style: .default)
         alert.addAction(okAction)
         present(alert, animated: true)
     }
    
    @IBAction func StatureTextField(_ sender: UITextField) {
        view.endEditing(true)
    }
    
    @IBAction func KeyBoardTabGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
}
