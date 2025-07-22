//
//  OtherMessageTableViewCell.swift
//  Sesac250718Report
//
//  Created by 유태호 on 7/19/25.
//

import UIKit

class OtherMessageTableViewCell: UITableViewCell {
    
    @IBOutlet var otherProfileImage: UIImageView!
    
    @IBOutlet var otherChatNameLabel: UILabel!
    
    @IBOutlet var otherChatTextLabel: UILabel!
    
    @IBOutlet var otherChatTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI() {
        // 셀 선택 스타일 제거
        selectionStyle = .none
        
        // 프로필 이미지 설정
        otherProfileImage.contentMode = .scaleAspectFill
        otherProfileImage.clipsToBounds = true
        otherProfileImage.layer.cornerRadius = 30
        otherProfileImage.backgroundColor = UIColor.lightGray
        
        // 이름 라벨 설정
        otherChatNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        otherChatNameLabel.textColor = .label
        otherChatNameLabel.numberOfLines = 1
        
        // 메시지 라벨 설정
        otherChatTextLabel.font = UIFont.systemFont(ofSize: 16)
        otherChatTextLabel.layer.borderWidth = 1.0
        otherChatTextLabel.layer.borderColor = UIColor.systemGray4.cgColor
        otherChatTextLabel.layer.cornerRadius = 6
        otherChatTextLabel.layer.masksToBounds = true
        
        
        /// 해당부분 미적용됨, 확인필요
        otherChatTextLabel.numberOfLines = 0
        otherChatTextLabel.textAlignment = .left
        
        otherChatTextLabel.lineBreakMode = .byWordWrapping
        
        // 시간 라벨 설정
        otherChatTimeLabel.font = UIFont.systemFont(ofSize: 12)
        otherChatTimeLabel.textColor = .tertiaryLabel
        otherChatTimeLabel.textAlignment = .left
        otherChatTimeLabel.numberOfLines = 1
    }
    
    func configure(with chat: Chat) {
        // 프로필 이미지 설정
        otherProfileImage.image = UIImage(named: chat.user.image)
        
        // 이름 설정
        otherChatNameLabel.text = chat.user.name
        
        // 메시지 텍스트 설정 (패딩을 위해 앞뒤로 공백 추가)
        otherChatTextLabel.text = "  \(chat.message)  "
        
        // 시간 포맷팅
        otherChatTimeLabel.text = formatTime(chat.date)
    }
    
    // 시간 포맷팅 함수
    //
    private func formatTime(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"
        
        return outputFormatter.string(from: date)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // 선택 효과 없음
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        otherProfileImage.image = nil
        otherChatNameLabel.text = nil
        otherChatTextLabel.text = nil
        otherChatTimeLabel.text = nil
    }
}
