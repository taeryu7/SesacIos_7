//
//  NumberViewController.swift
//  SeSac250711Report
//
//  Created by 유태호 on 7/12/25.
//

import UIKit

class NumberViewController: UIViewController {
    
    @IBOutlet var numberTextField: UITextField!
    
    @IBOutlet var numberLabel: UILabel!
    
    @IBOutlet var textLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 텍스트필드에 액션 추가
        /// editingChanged : 텍스트가 변경될때마다 바로 반응
        numberTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        // 초기 설정
        numberLabel.text = ""
        textLabel.text = "숫자를 입력해주세요"
        numberLabel.numberOfLines = 0  // 여러 줄 표시 가능
    }
    
    @objc func textFieldDidChange() {
        guard let text = numberTextField.text,
              let inputNumber = Int(text),
              inputNumber > 0 else {
            numberLabel.text = ""
            textLabel.text = "숫자를 입력해주세요"
            return
        }
        
        // 1부터 입력한 숫자까지의 369 게임 결과 생성
        let gameResult = generateThreeSixNineGame(upTo: inputNumber)
        numberLabel.text = gameResult.sequence
        
        // 총 박수 횟수 계산
        let totalClaps = countTotalClaps(upTo: inputNumber)
        textLabel.text = "\(inputNumber)까지 총 박수는 \(totalClaps)번입니다"
    }
    
    // 369 게임 시퀀스 생성
    func generateThreeSixNineGame(upTo number: Int) -> (sequence: String, totalClaps: Int) {
        var result: [String] = []
        var totalClaps = 0
        
        for i in 1...number {
            let claps = countClapsForNumber(i)
            if claps > 0 {
                let clapString = String(repeating: "👏", count: claps)
                result.append(clapString)
                totalClaps += claps
            } else {
                result.append("\(i)")
            }
        }
        
        return (result.joined(separator: ", "), totalClaps)
    }
    
    // 특정 숫자에서 박수 횟수 계산
    func countClapsForNumber(_ number: Int) -> Int {
        let numberString = String(number)
        var clapCount = 0
        
        for char in numberString {
            if char == "3" || char == "6" || char == "9" {
                clapCount += 1
            }
        }
        
        return clapCount
    }
    
    // 1부터 특정 숫자까지 총 박수 횟수 계산
    func countTotalClaps(upTo number: Int) -> Int {
        var totalClaps = 0
        
        for i in 1...number {
            totalClaps += countClapsForNumber(i)
        }
        
        return totalClaps
    }
}
