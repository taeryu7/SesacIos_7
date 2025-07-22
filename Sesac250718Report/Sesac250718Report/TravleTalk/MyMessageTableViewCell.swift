//
//  MyMessageTableViewCell.swift
//  Sesac250718Report
//
//  Created by 유태호 on 7/19/25.
//

import UIKit

class MyMessageTableViewCell: UITableViewCell {
    
    @IBOutlet var myMessageTextLabel: UILabel!
    
    @IBOutlet var myMessageTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI() {
        // 셀 선택 스타일 제거
        selectionStyle = .none
        
        // 메시지 라벨 설정
        myMessageTextLabel.font = UIFont.systemFont(ofSize: 16)
        myMessageTextLabel.layer.borderWidth = 1.0
        myMessageTextLabel.layer.borderColor = UIColor.systemGray4.cgColor
        myMessageTextLabel.layer.cornerRadius = 6
        myMessageTextLabel.layer.masksToBounds = true
        myMessageTextLabel.numberOfLines = 0
        myMessageTextLabel.textAlignment = .left
        
        // Dynamic Height적용코드? 되는거여 안되는거여
        myMessageTextLabel.lineBreakMode = .byWordWrapping
        
        // 패딩을 위한 inset 설정 (텍스트가 모서리에 닿지 않도록)
        myMessageTextLabel.layer.sublayerTransform = CATransform3DMakeTranslation(8, 4, 0)
        
        // 시간 라벨 설정
        myMessageTimeLabel.font = UIFont.systemFont(ofSize: 12)
        myMessageTimeLabel.textColor = .tertiaryLabel
        myMessageTimeLabel.textAlignment = .right
        myMessageTimeLabel.numberOfLines = 1
    }
    
    func configure(with chat: Chat) {
        // 메시지 텍스트 설정 (패딩을 위해 앞뒤로 공백 추가)
        myMessageTextLabel.text = "  \(chat.message)  "
        
        // 시간 포맷팅
        myMessageTimeLabel.text = formatTime(chat.date)
    }
    
    // 시간 포맷팅 함수
    private func formatTime(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.dateFormat = "HH:mm a"
        
        return outputFormatter.string(from: date)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        myMessageTextLabel.text = nil
        myMessageTimeLabel.text = nil
    }
}
