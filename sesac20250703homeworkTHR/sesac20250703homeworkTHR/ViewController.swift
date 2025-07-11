//
//  ViewController.swift
//  sesac20250703homeworkTHR
//
//  Created by 유태호 on 7/3/25.
//

import UIKit

final class ViewController: UIViewController {

    
    @IBOutlet var searchTextField: UITextField!
    
    @IBOutlet var searchButton: UIButton!
    
    @IBOutlet var answerLabel: UILabel!
    
    @IBOutlet var answerImageView: UIImageView!
    
    @IBOutlet var wordButton: [UIButton]!
    let NewWordList = ["에겐남", "테토남", "에겐녀", "테토녀", "손절미", "무지컬", "밥플릭스", "테무인간", "한플루언서", "수발새끼", "랜선생님", "위쑤시개"]
    
    let NewWordDictionary: [String: String] = [
            "에겐남" : "여성호르몬인 '에스트로겐 (estrogen)'이 많이 느껴지는 남성을 뜻하며, 주로 다정하고 섬세하며 감정에 민감한 성향을 지닌다.",
            "테토남" : "남성호르몬인 '테스토스테론 (testosterone)'의 특성이 강하게 드러나는 남성을 뜻하며, 리더십이 있고 직설적이며 주도적인 남성",
            "에겐녀" : "여성호르몬인 '에스트로겐 (estrogen)'이 많이 느껴지는 여성을 뜻하며, 주로 다정하고 섬세하며 감정에 민감한 성향을 지닌다.",
            "테토녀" : "남성호르몬인 '테스토스테론 (testosterone)'의 특성이 강하게 드러나는 여성을 뜻하며, 털털하고 쿨한 성격의 여성",
            "손절미" : "손절하고 싶어지는 특징",
            "무지컬" : "피지컬도 없고 뇌지컬도 없는 사람. 육체적으로도 두뇌적으로도 뛰어나지 않은 사람을 일컫는다.",
            "밥플릭스" : "밥 먹으면서 보는 영상. 요즘 현대인들은 식사를 하며 '넷플릭스' 등의 OTT 플랫폼을 자주 이용한다.",
            "테무인간" : "일은 열심히 하는데 퀄리티는 별로인 사람. '테무'는 중국 전자상거래 회사인 핀둬둬가 운영하는 온라인 시장으로, 주로 중국에서 직접 소비자에게 배송되는 소비재를 대폭 할인된 가격으로 제공한다. 그러나 제품의 퀄리티가 현저히 떨어지는 경우가 더러 있어 '테무산 OO'이라는 단어로도 많이 활용된다.",
            "한플루언서" : "한숨을 너무 크게 쉬어서 주변에 영향을 주는 사람.",
            "수발새끼" : "여행 갔는데 손 까딱 안하고 수발 들어줘야 하는 사람",
            "랜선생님" : "랜선 상 비대면으로 만났지만 큰 가르침을 주는 사람",
            "위쑤시개" : "스트레스를 받을 때 매운 음식으로 해소하려는 행동이나 음식을 지칭합니다."
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupRandomWordButtons()
    }
    
    private func configureUI() {
        searchTextField.placeholder = "신조어를 검색하세요"
        searchTextField.borderStyle = .roundedRect
                
        answerLabel.text = ""
        answerLabel.textAlignment = .center
        answerLabel.numberOfLines = 0
        answerLabel.lineBreakMode = .byWordWrapping
        
        answerImageView.image = UIImage(named: "word_logo")
        
    }
    
    private func searchNewWord() {
        /// .trimmingCharacters(in:): 지정한 문자들 제거
        /// .whitespacesAndNewlines: 공백과 줄바꿈 문자 집합
        /// 사용자가 실수로 공백, 줄바꿈(엔터) 적용시에 검색 안되는 현상 방지
        guard let searchText = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !searchText.isEmpty else {
            answerLabel.text = "검색어를 입력하세요"
            answerLabel.textAlignment = .center
            answerImageView.image = UIImage(named: "background")
            return
        }
        
        if let meaning = NewWordDictionary[searchText] {
            answerLabel.text = meaning
            answerImageView.image = UIImage(named: "background")
            
            if meaning.count <= 30 {
                answerLabel.textAlignment = .center
            } else {
                /// justified : 양쪽 끝을 맞추기 위해 단어 사이 간격을 자동 조정하는 속성
                answerLabel.textAlignment = .justified
            }
            
        } else {
            answerLabel.text = "검색결과가 없습니다"
            answerLabel.textAlignment = .center
        }
        
    }
    
    private func setupRandomWordButtons() {
        let shuffledWords = NewWordList.shuffled()
        
        for (index, button) in wordButton.enumerated() {
            if index < shuffledWords.count {
                button.setTitle(shuffledWords[index], for: .normal)
            }
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.clipsToBounds = true
            
            print("Button \(index) font: \(button.titleLabel?.font?.pointSize ?? 0)")
            
        }
    }
    
    private func RandomWordButton() {
        setupRandomWordButtons()
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        searchNewWord()
        view.endEditing(true)
    }
    
    @IBAction func keyboardDissMissTabGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func wordButtonTapped(_ sender: UIButton) {
        guard let wordText = sender.title(for: .normal) else { return }
        searchTextField.text = wordText
        searchNewWord()
        view.endEditing(true)
    }
    
}

