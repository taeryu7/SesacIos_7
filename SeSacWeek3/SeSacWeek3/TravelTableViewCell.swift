//
//  TravelTableViewCell.swift
//  SeSACWEEK3
//
//  Created by YoungJin on 7/14/25.
//

import UIKit

class TravelTableViewCell: UITableViewCell {

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var travelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        travelLabel.backgroundColor = .yellow
        travelLabel.text = "TEST"
        travelLabel.font = .systemFont(ofSize: 30)
        
        travelLabel.backgroundColor = .clear
        dateLabel.backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .white
    }
    
    func configureUI(_ data: Travel) {
        travelLabel.text = data.overView
        travelLabel.numberOfLines = 0
        
        dateLabel.text = data.name
        
        // 100% 모든 셀의 배경에 대해서 대응
        // else 가 없다면 이상해짐
        // 1. else 로
        // 2. 재사용 시 배경 없애기
        //
        if data.like {
            backgroundColor = .yellow
        }
        
//        else {
//            backgroundColor = .clear
//        }
    }
}
