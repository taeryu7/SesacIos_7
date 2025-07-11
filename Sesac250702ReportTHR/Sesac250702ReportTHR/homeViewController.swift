//
//  homeViewController.swift
//  Sesac250702ReportTHR
//
//  Created by 유태호 on 7/2/25.
//

import UIKit

class homeViewController: UIViewController {
    
    @IBOutlet var arrayImageView: [UIImageView]!
    
    @IBOutlet var bottomTopLabel: [UILabel]!
    
    @IBOutlet var bottomBottomLabel: [UILabel]!
    
    @IBOutlet var arrayTopTenImageView: [UIImageView]!
    
    
    let imageNames = ["1", "2", "3", "4", "5", "극한직업", "노량", "더퍼스트슬램덩크", "도둑들", "명량", "밀수", "범죄도시3", "베테랑", "부산행", "서울의봄", "스즈메의문단속", "신과함께인과연", "신과함께죄와벌", "아바타", "아바타물의길", "알라딘", "암살", "어벤져스엔드게임", "오펜하이머", "왕의남자", "육사오", "콘크리트유토피아", "태극기휘날리며", "택시운전사", "해운대"]
    
    let bottomHidden = [true , false]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for imageView in arrayImageView {
            imageViewUI(IV: imageView, CR: 10, CTB: true)
        }
        
        for bottomTopLabel in bottomTopLabel {
            bottomTopLabelUI(
                LB: bottomTopLabel, LT: "새로운에피소드"
            )
        }
        
        for bottomBottomLabel in bottomBottomLabel {
            bottomBottomLabelUI(
                LB: bottomBottomLabel, LT: "지금시청하기"
            )
        }
        
        topTenImageViewUI()
        
        setRandomImages()
        
        setRandomLabels()
    }

    private func imageViewUI(
        IV imageView: UIImageView,
        CR cornerradius: CGFloat = 10,
        CTB clipstobounds: Bool = true
        ) {
        imageView.layer.cornerRadius = cornerradius
        imageView.clipsToBounds = clipstobounds
    }
    
    private func bottomTopLabelUI(
        LB label: UILabel,
        LT labelText: String,

    ) {
        label.text = labelText
        label.textColor = .white
        label.backgroundColor = .red
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.numberOfLines = 2
    }
    
    private func bottomBottomLabelUI(
        LB label: UILabel,
        LT labelText: String,

    ) {
        label.text = labelText
        label.textColor = .black
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
    }
    
    private func topTenImageViewUI() {
        for imageView in arrayTopTenImageView {
            imageView.image = UIImage(named: "top10 badge")
        }
    }
    
    private func setRandomImages() {
        for imageView in arrayImageView {
            let randomIndex = Int.random(in: 0..<imageNames.count)
            imageView.image = UIImage(named: imageNames[randomIndex])
        }
    }
    
    private func setRandomLabels() {
        for bottomHidden in arrayTopTenImageView {
            bottomHidden.isHidden = Bool.random()
        }
        
        for bottomHiddin in bottomTopLabel {
            bottomHiddin.isHidden = Bool.random()
        }
        
        for bottomHiddin in bottomBottomLabel {
            bottomHiddin.isHidden = Bool.random()
        }
    }
    
    @IBAction func playPosterRandomButton(_ sender: Any) {
        setRandomImages()
        setRandomLabels()
    }
    
    @IBAction func playAlertRandomButton(_ sender: Any) {
        setRandomLabels()
    }
    
    
}
