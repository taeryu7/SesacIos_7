//
//  emotionViewController.swift
//  Sesac250701ReportTHR
//
//  Created by 유태호 on 7/1/25.
//

import UIKit

class emotionViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var firstButton: UIButton!
    @IBOutlet var firstLabel: UILabel!
    
    @IBOutlet var secondButton: UIButton!
    @IBOutlet var secondLabel: UILabel!
    
    @IBOutlet var thirdButton: UIButton!
    @IBOutlet var thirdLabel: UILabel!
    
    @IBOutlet var fourthButton: UIButton!
    @IBOutlet var fourthLabel: UILabel!
    
    @IBOutlet var fifthButton: UIButton!
    @IBOutlet var fifthLabel: UILabel!
    
    @IBOutlet var sixthButton: UIButton!
    @IBOutlet var sixthLabel: UILabel!
    
    @IBOutlet var seventhButton: UIButton!
    @IBOutlet var seventhLabel: UILabel!
    
    @IBOutlet var eighthButton: UIButton!
    @IBOutlet var eighthLabel: UILabel!
    
    @IBOutlet var ninthButton: UIButton!
    @IBOutlet var ninthLabel: UILabel!
    
    @IBOutlet var allupButton: UIButton!
    
    @IBOutlet var allRandomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabelUI()
        firstButtonUI()
        firstLabelUI()
        secondButtonUI()
        secondLabelUI()
        thirdButtonUI()
        thirdLabelUI()
        fourthButtonUI()
        fourthLabelUI()
        fifthButtonUI()
        fifthLabelUI()
        sixthButtonUI()
        sixthLabelUI()
        seventhButtonUI()
        seventhLabelUI()
        eighthButtonUI()
        eighthLabelUI()
        ninthButtonUI()
        ninthLabelUI()
    }
    
    private func titleLabelUI() {
        titleLabel.textColor = UIColor.black
        titleLabel.text = "감정다이어리"
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.alpha = 0.8
        titleLabel.layer.cornerRadius = 10
        titleLabel.clipsToBounds = true
    }

    
    private func firstButtonUI() {
        var config = UIButton.Configuration.plain()
        config.background.image = UIImage(named: "mono_slime1")
        config.background.imageContentMode = .scaleAspectFit
        config.title = ""
        firstButton.configuration = config
    }
    
    
    private func firstLabelUI() {
        firstLabel.textColor = UIColor.black
        firstLabel.text = "행복해"
        firstLabel.textAlignment = NSTextAlignment.center
        firstLabel.font = UIFont.systemFont(ofSize: 20)
        firstLabel.textAlignment = NSTextAlignment.center
        firstLabel.alpha = 0.8
        firstLabel.layer.cornerRadius = 10
        firstLabel.clipsToBounds = true
    }
    
    private func secondButtonUI() {
        var config = UIButton.Configuration.plain()
        config.background.image = UIImage(named: "mono_slime2")
        config.background.imageContentMode = .scaleAspectFit
        config.title = ""
        secondButton.configuration = config
    }
    
    private func secondLabelUI() {
        secondLabel.textColor = UIColor.black
        secondLabel.text = "사랑해"
        secondLabel.textAlignment = NSTextAlignment.center
        secondLabel.font = UIFont.systemFont(ofSize: 20)
        secondLabel.textAlignment = NSTextAlignment.center
        secondLabel.alpha = 0.8
        secondLabel.layer.cornerRadius = 10
        secondLabel.clipsToBounds = true
    }
    
    private func thirdButtonUI() {
        var config = UIButton.Configuration.plain()
        config.background.image = UIImage(named: "mono_slime3")
        config.background.imageContentMode = .scaleAspectFit
        config.title = ""
        thirdButton.configuration = config
    }
    
    private func thirdLabelUI() {
        thirdLabel.textColor = UIColor.black
        thirdLabel.text = "좋아해"
        thirdLabel.textAlignment = NSTextAlignment.center
        thirdLabel.font = UIFont.systemFont(ofSize: 20)
        thirdLabel.textAlignment = NSTextAlignment.center
        thirdLabel.alpha = 0.8
        thirdLabel.layer.cornerRadius = 10
        thirdLabel.clipsToBounds = true
    }
    
    private func fourthButtonUI() {
        var config = UIButton.Configuration.plain()
        config.background.image = UIImage(named: "mono_slime4")
        config.background.imageContentMode = .scaleAspectFit
        config.title = ""
        fourthButton.configuration = config
    }
    
    private func fourthLabelUI() {
        fourthLabel.textColor = UIColor.black
        fourthLabel.text = "당황해"
        fourthLabel.textAlignment = NSTextAlignment.center
        fourthLabel.font = UIFont.systemFont(ofSize: 20)
        fourthLabel.textAlignment = NSTextAlignment.center
        fourthLabel.alpha = 0.8
        fourthLabel.layer.cornerRadius = 10
        fourthLabel.clipsToBounds = true
    }
    
    private func fifthButtonUI() {
        var config = UIButton.Configuration.plain()
        config.background.image = UIImage(named: "mono_slime5")
        config.background.imageContentMode = .scaleAspectFit
        config.title = ""
        fifthButton.configuration = config
    }
    
    private func fifthLabelUI() {
        fifthLabel.textColor = UIColor.black
        fifthLabel.text = "속상해"
        fifthLabel.textAlignment = NSTextAlignment.center
        fifthLabel.font = UIFont.systemFont(ofSize: 20)
        fifthLabel.textAlignment = NSTextAlignment.center
        fifthLabel.alpha = 0.8
        fifthLabel.layer.cornerRadius = 10
        fifthLabel.clipsToBounds = true
    }
    
    private func sixthButtonUI() {
        var config = UIButton.Configuration.plain()
        config.background.image = UIImage(named: "mono_slime6")
        config.background.imageContentMode = .scaleAspectFit
        config.title = ""
        sixthButton.configuration = config
    }
    
    private func sixthLabelUI() {
        sixthLabel.textColor = UIColor.black
        sixthLabel.text = "우울해"
        sixthLabel.textAlignment = NSTextAlignment.center
        sixthLabel.font = UIFont.systemFont(ofSize: 20)
        sixthLabel.textAlignment = NSTextAlignment.center
        sixthLabel.alpha = 0.8
        sixthLabel.layer.cornerRadius = 10
        sixthLabel.clipsToBounds = true
    }
    
    private func seventhButtonUI() {
        var config = UIButton.Configuration.plain()
        config.background.image = UIImage(named: "mono_slime7")
        config.background.imageContentMode = .scaleAspectFit
        config.title = ""
        seventhButton.configuration = config
    }
    
    private func seventhLabelUI() {
        seventhLabel.textColor = UIColor.black
        seventhLabel.text = "심심해"
        seventhLabel.textAlignment = NSTextAlignment.center
        seventhLabel.font = UIFont.systemFont(ofSize: 20)
        seventhLabel.textAlignment = NSTextAlignment.center
        seventhLabel.alpha = 0.8
        seventhLabel.layer.cornerRadius = 10
        seventhLabel.clipsToBounds = true
    }
    
    private func eighthButtonUI() {
        var config = UIButton.Configuration.plain()
        config.background.image = UIImage(named: "mono_slime8")
        config.background.imageContentMode = .scaleAspectFit
        config.title = ""
        eighthButton.configuration = config
    }
    
    private func eighthLabelUI() {
        eighthLabel.textColor = UIColor.black
        eighthLabel.text = "침울해"
        eighthLabel.textAlignment = NSTextAlignment.center
        eighthLabel.font = UIFont.systemFont(ofSize: 20)
        eighthLabel.textAlignment = NSTextAlignment.center
        eighthLabel.alpha = 0.8
        eighthLabel.layer.cornerRadius = 10
        eighthLabel.clipsToBounds = true
    }
    
    private func ninthButtonUI() {
        var config = UIButton.Configuration.plain()
        config.background.image = UIImage(named: "mono_slime9")
        config.background.imageContentMode = .scaleAspectFit
        config.title = ""
        ninthButton.configuration = config
    }
    
    private func ninthLabelUI() {
        ninthLabel.textColor = UIColor.black
        ninthLabel.text = "눈물나"
        ninthLabel.textAlignment = NSTextAlignment.center
        ninthLabel.font = UIFont.systemFont(ofSize: 20)
        ninthLabel.textAlignment = NSTextAlignment.center
        ninthLabel.alpha = 0.8
        ninthLabel.layer.cornerRadius = 10
        ninthLabel.clipsToBounds = true
    }
    
    
    @IBAction func firstButtonAction(_ sender: Any) {
        firstLabel.text = "행복해 \(Int.random(in: 1...999))"
    }
    
    @IBAction func secondButtonAction(_ sender: Any) {
        secondLabel.text = "사랑해 \(Int.random(in: 1...999))"
    }
    
    @IBAction func thirdBottonAction(_ sender: Any) {
        thirdLabel.text = "좋아해 \(Int.random(in: 1...999))"
    }
    
    @IBAction func forthButtonAction(_ sender: Any) {
        fourthLabel.text = "당황해 \(Int.random(in: 1...999))"
    }
    
    @IBAction func fifthButtonAction(_ sender: Any) {
        fifthLabel.text = "속상해 \(Int.random(in: 1...999))"
    }
    
    @IBAction func sixthButtonAction(_ sender: Any) {
        sixthLabel.text = "우울해 \(Int.random(in: 1...999))"
    }
    
    @IBAction func seventhButtonAction(_ sender: Any) {
        seventhLabel.text = "심심해 \(Int.random(in: 1...999))"
    }
    
    @IBAction func eighthButtonAction(_ sender: Any) {
        eighthLabel.text = "침울해 \(Int.random(in: 1...999))"
    }
    
    @IBAction func ninethButtonAction(_ sender: Any) {
        ninthLabel.text = "눈물나 \(Int.random(in: 1...999))"
    }
    
    @IBAction func allupbutton(_ sender: Any) {
        updateLabelCount(label: firstLabel, emotion: "행복해")
        updateLabelCount(label: secondLabel, emotion: "사랑해")
        updateLabelCount(label: thirdLabel, emotion: "좋아해")
        updateLabelCount(label: fourthLabel, emotion: "당황해")
        updateLabelCount(label: fifthLabel, emotion: "속상해")
        updateLabelCount(label: sixthLabel, emotion: "우울해")
        updateLabelCount(label: seventhLabel, emotion: "심심해")
        updateLabelCount(label: eighthLabel, emotion: "침울해")
        updateLabelCount(label: ninthLabel, emotion: "눈물나")
    }
    
    // 각 라벨의 숫자를 1씩 증가시키는 함수
    private func updateLabelCount(label: UILabel, emotion: String) {
        guard let currentText = label.text else { return }
        
        // "감정해 숫자" 형태에서 숫자 부분 추출
        if currentText.contains(" ") {
            let components = currentText.components(separatedBy: " ")
            if components.count == 2, let currentNumber = Int(components[1]) {
                // 기존 숫자에서 1 증가
                label.text = "\(emotion) \(currentNumber + 1)"
            } else {
                // 숫자가 없으면 1부터 시작
                label.text = "\(emotion) 1"
            }
        } else {
            // 숫자가 없으면 1부터 시작
            label.text = "\(emotion) 1"
        }
    }
    
    @IBAction func allrandombutton(_ sender: Any) {
        firstLabel.text = "행복해 \(Int.random(in: 1...999))"
        secondLabel.text = "사랑해 \(Int.random(in: 1...999))"
        thirdLabel.text = "좋아해 \(Int.random(in: 1...999))"
        fourthLabel.text = "당황해 \(Int.random(in: 1...999))"
        fifthLabel.text = "속상해 \(Int.random(in: 1...999))"
        sixthLabel.text = "우울해 \(Int.random(in: 1...999))"
        seventhLabel.text = "심심해 \(Int.random(in: 1...999))"
        eighthLabel.text = "침울해 \(Int.random(in: 1...999))"
        ninthLabel.text = "눈물나 \(Int.random(in: 1...999))"
    }
    
}
