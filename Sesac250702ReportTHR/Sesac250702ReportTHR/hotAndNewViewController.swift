//
//  hotAndNewViewController.swift
//  Sesac250702ReportTHR
//
//  Created by 유태호 on 7/2/25.
//

import UIKit

class hotAndNewViewController: UIViewController {

    
    @IBOutlet var collectionLabel: [UIButton]!

    @IBOutlet var labelCollection: [UILabel]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionButtonUI(
            LB: collectionLabel[0],
            BT: "공개예정"
        )
        
        collectionButtonUI(
            LB: collectionLabel[1],
            BT: "모두의 인기컨텐츠"
        )
        
        collectionButtonUI(
            LB: collectionLabel[2],
            BT: "Top10 시리즈"
        )
        
        labelUI(
            LB: labelCollection[0]
        )
        
        for (index, button) in collectionLabel.enumerated() {
            button.tag = index
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
        
    }
    
    private func collectionButtonUI(
        LB button: UIButton,
        BT buttonText: String
    ) {
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        button.titleLabel?.adjustsFontSizeToFitWidth = false
        button.setTitle(buttonText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func labelUI(
        LB label: UILabel
    ) {
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        selectButton(at: sender.tag)
    }
    
    private func selectButton(at index: Int) {
        for button in collectionLabel {
            button.backgroundColor = .clear
        }
        
        collectionLabel[index].backgroundColor = .gray
        
        if labelCollection.count > 0 {
            switch index {
            case 0: // 공개예정
                labelCollection[0].text = "곧 공개될 흥미진진한 작품들을 기다려주세요!"
            case 1: // 모두의 인기컨텐츠
                labelCollection[0].text = "지금 가장 인기있는 콘텐츠들을 만나보세요!"
            case 2: // Top10 시리즈
                labelCollection[0].text = "TOP 10 시리즈로 최고의 작품들을 확인하세요!"
            default:
                labelCollection[0].text = "다른 영화, 시리즈, 배우, 감독 또는 장르를 검색해보세요."
            }
        }
    }

}
