//
//  TravleAdTableViewCell.swift
//  SeSac250711Report
//
//  Created by 유태호 on 7/13/25.
//

import UIKit

class TravleAdTableViewCell: UITableViewCell {
    
    @IBOutlet var adUiView: UIView!
    
    @IBOutlet var adLabel: UILabel!
    
    @IBOutlet var adBadgeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI() {
        // adBadgeLabel 설정 (항상 AD 표시)
        adBadgeLabel.text = "AD"
        adBadgeLabel.backgroundColor = UIColor.systemRed
        adBadgeLabel.textColor = UIColor.white
        adBadgeLabel.layer.cornerRadius = 8
        adBadgeLabel.clipsToBounds = true
        adBadgeLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        // adUiView 랜덤 색상 설정
        setRandomBackgroundColor()
        
        // adUiView 모서리 둥글게
        adUiView.layer.cornerRadius = 12
        adUiView.clipsToBounds = true
    }
    
    // 랜덤 색상 설정 함수
    func setRandomBackgroundColor() {
        let colors: [UIColor] = [
            UIColor.systemBlue.withAlphaComponent(0.1),
            UIColor.systemGreen.withAlphaComponent(0.1),
            UIColor.systemOrange.withAlphaComponent(0.1),
            UIColor.systemPurple.withAlphaComponent(0.1),
            UIColor.systemPink.withAlphaComponent(0.1),
            UIColor.systemYellow.withAlphaComponent(0.1),
            UIColor.systemTeal.withAlphaComponent(0.1),
            UIColor.systemIndigo.withAlphaComponent(0.1)
        ]
        
        let randomColor = colors.randomElement() ?? UIColor.systemGray6
        adUiView.backgroundColor = randomColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
