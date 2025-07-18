//
//  TravleCollectionViewCell.swift
//  Sesac250718Report
//
//  Created by 유태호 on 7/18/25.
//

import UIKit

class TravleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var travleProfileImageView: UIImageView!
    
    @IBOutlet var travleNicknameLabel: UILabel!
    
    @IBOutlet var travleLastChatLabel: UILabel!
    
    @IBOutlet var TravleLastDateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI() {
        // 셀 전체 설정
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor.systemBackground
        
        // 그림자 효과
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
        
        // 프로필 이미지뷰 설정
        travleProfileImageView.contentMode = .scaleAspectFill
        travleProfileImageView.clipsToBounds = true
        travleProfileImageView.layer.cornerRadius = 40
        travleProfileImageView.backgroundColor = UIColor.lightGray
        
        // 닉네임 라벨 설정
        travleNicknameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        travleNicknameLabel.textColor = .label
        travleNicknameLabel.numberOfLines = 1
        
        // 마지막 채팅 라벨 설정
        travleLastChatLabel.font = UIFont.systemFont(ofSize: 14)
        travleLastChatLabel.textColor = .secondaryLabel
        travleLastChatLabel.numberOfLines = 2
        
        // 마지막 날짜 라벨 설정
        TravleLastDateLabel.font = UIFont.systemFont(ofSize: 12)
        TravleLastDateLabel.textColor = .tertiaryLabel
        TravleLastDateLabel.numberOfLines = 1
    }
    
    func configure(with chatRoom: ChatRoom) {
        // 채팅방 이름 설정
        travleNicknameLabel.text = chatRoom.chatroomName
        
        // 프로필 이미지 설정
        travleProfileImageView.image = UIImage(named: chatRoom.chatroomImage)
        
        // 마지막 채팅 메시지와 날짜 설정
        if let lastChat = chatRoom.chatList.last {
            travleLastChatLabel.text = lastChat.message
            TravleLastDateLabel.text = formatDate(lastChat.date)
        } else {
            travleLastChatLabel.text = "아직 대화가 없습니다."
            TravleLastDateLabel.text = ""
        }
    }
    
    // 날짜 포맷팅 함수
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yy.MM.dd"
        
        return outputFormatter.string(from: date)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        travleProfileImageView.image = nil
        travleNicknameLabel.text = nil
        travleLastChatLabel.text = nil
        TravleLastDateLabel.text = nil
    }
}
