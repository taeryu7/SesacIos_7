//
//  ViewController.swift
//  20250708SeSacReport
//
//  Created by 유태호 on 7/8/25.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var SettingButton: UIButton!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var statusImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var statLabel: UILabel!
    @IBOutlet var eatTextField: UITextField!
    @IBOutlet var eatButton: UIButton!
    @IBOutlet var drinkTextField: UITextField!
    @IBOutlet var drinkButton: UIButton!
    
    // 메시지 구조체
    struct Messages {
        static let welcome = [
            "안녕하세요! 오늘도 좋은 하루 되세요",
            "반가워요! 오늘은 어떤 하루인가요?",
            "좋은 아침이에요! 오늘도 함께해요",
            "어서오세요! 저를 돌봐주세요",
            "오늘도 만나서 반가워요!"
        ]
        
        static let eat = [
            "맛있어요! 고마워요",
            "냠냠! 정말 맛있네요",
            "밥을 먹으니 힘이 나요!",
            "더 먹고 싶어요!",
            "밥 덕분에 기분이 좋아졌어요",
            "영양가 있는 밥이네요!",
            "배가 든든해졌어요"
        ]
        
        static let drink = [
            "시원해요! 목이 말랐는데 고마워요",
            "물이 정말 맛있어요!",
            "갈증이 해소됐어요",
            "시원한 물 덕분에 상쾌해요",
            "물을 마시니 건강해진 것 같아요",
            "깨끗한 물이네요!",
            "수분 보충 완료!"
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 메시지라벨 여러줄 설정
        messageLabel.numberOfLines = 0 // 0으로 설정시 무한대, 그외는 1이상으로 끊을수 있다고함.
        messageLabel.lineBreakMode = .byWordWrapping // 단어기준 줄엔터처리
        updateNameLabel()
        updateStatLabel()
        updateTamagotchiImage()
        showWelcomeMessage()
        //resetUserDefaults()
    }
    
    /// 우측상단 버튼으로 화면 전환시 뷰 새로 조정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNameLabel()
        updateStatLabel()
        updateTamagotchiImage()
        showWelcomeMessage()
    }
    
    @IBAction func eatTextLabel(_ sender: UITextField) {
        view.endEditing(true)
    }
    
    @IBAction func eatButtonTapped(_ sender: UIButton) {
        let eatText = eatTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        var eatCount = 1 // 기본값: 1개
        
        // "밥주세용" 텍스트나 비어있을 때는 기본값 1개 적용
        if !eatText.isEmpty && eatText != "밥주세용" {
            guard let inputNumber = Int(eatText) else {
                messageLabel.text = "숫자만 입력해주세요!"
                return
            }
            
            guard inputNumber < 100 else {
                messageLabel.text = "99개까지만 먹을 수 있어요!"
                return
            }
            
            guard inputNumber > 0 else {
                messageLabel.text = "1개 이상 입력해주세요!"
                return
            }
            
            eatCount = inputNumber
        }
        
        // 총 먹은 개수 저장
        let currentEatCount = UserDefaults.standard.integer(forKey: eatCountKey)
        UserDefaults.standard.set(currentEatCount + eatCount, forKey: eatCountKey)
        
        showEatMessage(count: eatCount)
        updateStatLabel()
        updateTamagotchiImage()
        eatTextField.text = ""
        view.endEditing(true)
    }
    
    @IBAction func drinkTextLabel(_ sender: UITextField) {
        view.endEditing(true)
    }
    
    @IBAction func drinkButtonTapped(_ sender: UIButton) {
        let drinkText = drinkTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        var drinkCount = 1 // 기본값: 1개
        
        // "물주세용" 텍스트나 비어있을 때는 기본값 1개 적용
        if !drinkText.isEmpty && drinkText != "물주세용" {
            guard let inputNumber = Int(drinkText) else {
                messageLabel.text = "숫자만 입력해주세요!"
                return
            }
            
            guard inputNumber < 50 else {
                messageLabel.text = "49개까지만 마실 수 있어요!"
                return
            }
            
            guard inputNumber > 0 else {
                messageLabel.text = "1개 이상 입력해주세요!"
                return
            }
            
            drinkCount = inputNumber
        }
        
        // 총 마신 개수 저장
        let currentDrinkCount = UserDefaults.standard.integer(forKey: drinkCountKey)
        UserDefaults.standard.set(currentDrinkCount + drinkCount, forKey: drinkCountKey)
        
        showDrinkMessage(count: drinkCount)
        updateStatLabel()
        updateTamagotchiImage()
        drinkTextField.text = ""
        view.endEditing(true)
    }
    
    
    private let eatCountKey = "eatCount"
    private let drinkCountKey = "drinkCount"
    
    private func calculateLevel() -> Int {
        let totalEatCount = UserDefaults.standard.integer(forKey: eatCountKey)
        let totalDrinkCount = UserDefaults.standard.integer(forKey: drinkCountKey)
        
        let levelValue = (Double(totalEatCount) / 5.0) + (Double(totalDrinkCount) / 2.0)
        
        // 0~9 → 1, 10~19 → 2, ..., 70~79 → 8, 80~89 → 9
        let level = Int(levelValue / 10) + 1
        
        // 99 초과일 때 레벨 10
        if levelValue > 99 {
            return 10
        }
        
        // 최소 레벨 1
        return max(level, 1)
    }
    
    private func updateStatLabel() {
        let totalEatCount = UserDefaults.standard.integer(forKey: eatCountKey)
        let totalDrinkCount = UserDefaults.standard.integer(forKey: drinkCountKey)
        let currentLevel = calculateLevel()
        
        statLabel.text = "LV.\(currentLevel) • 밥알 \(totalEatCount)개 • 물방울 \(totalDrinkCount)개"
    }
    
    private func updateTamagotchiImage() {
        let level = calculateLevel()
        let imageName = "2-\(level)" // 2-1, 2-2, ... 2-9, 2-10
        statusImageView.image = UIImage(named: imageName)
    }
    
    private func updateNameLabel() {
        let userName = UserDefaults.standard.string(forKey: "name") ?? "대장"
        nameLabel.text = "\(userName)님의 다마고치"
    }
    
    // 환영 메시지 표시 함수
    private func showWelcomeMessage() {
        let userName = UserDefaults.standard.string(forKey: "name") ?? "대장"
        let randomWelcome = Messages.welcome.randomElement() ?? "안녕하세요!"
        messageLabel.text = "\(randomWelcome), \(userName)님!"
    }
    
    // 밥 먹기 메시지 표시 함수 (개수 포함)
    private func showEatMessage(count: Int) {
        let userName = UserDefaults.standard.string(forKey: "name") ?? "대장"
        let randomEat = Messages.eat.randomElement() ?? "맛있어요!"
        messageLabel.text = "\(randomEat) 밥알 \(count)개를 먹었어요! \(userName)님!"
    }
    
    // 물 마시기 메시지 표시 함수 (개수 포함)
    private func showDrinkMessage(count: Int) {
        let userName = UserDefaults.standard.string(forKey: "name") ?? "대장"
        let randomDrink = Messages.drink.randomElement() ?? "시원해요!"
        messageLabel.text = "\(randomDrink) 물방울 \(count)개를 마셨어요! \(userName)님!"
    }
    
    
    // 테스트용함수, UserDefaults 데이터 지우기 위한 코드로 사용후 바로 지워서 테스트 다시 진행 할 것
    private func resetUserDefaults() {
        UserDefaults.standard.removeObject(forKey: eatCountKey)
        UserDefaults.standard.removeObject(forKey: drinkCountKey)
        UserDefaults.standard.removeObject(forKey: "name")
        
        // 즉시 UI 업데이트
        updateNameLabel()
        updateStatLabel()
        updateTamagotchiImage()
        showWelcomeMessage()
    }

}

