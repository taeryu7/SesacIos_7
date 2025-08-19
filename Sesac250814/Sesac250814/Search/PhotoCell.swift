//
//  PhotoCell.swift
//  Sesac250814
//
//  Created by 유태호 on 8/14/25.
//

import UIKit
import SnapKit

class PhotoCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let likeButton = UIButton()
    private let likesLabel = UILabel()
    private var currentPhotoId: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 8
        clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        likeButton.tintColor = .white
        likeButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        likeButton.layer.cornerRadius = 15
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        likesLabel.font = .systemFont(ofSize: 12, weight: .medium)
        likesLabel.textColor = .white
        likesLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        likesLabel.layer.cornerRadius = 8
        likesLabel.textAlignment = .center
        likesLabel.clipsToBounds = true
    }
    
    private func setupLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(likesLabel)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.width.height.equalTo(30)
        }
        
        likesLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(8)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(40)
        }
    }
    
    func configure(with photo: Photo) {
        currentPhotoId = photo.id
        
        // 좋아요 수 표시 (콤마 포함)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let likesText = formatter.string(from: NSNumber(value: photo.likes)) ?? "\(photo.likes)"
        likesLabel.text = "⭐ \(likesText)"
        
        // 좋아요 상태 설정 (UserDefaults에서 확인)
        let isLiked = UserDefaults.standard.bool(forKey: "liked_\(photo.id)")
        likeButton.isSelected = isLiked
        likeButton.tintColor = isLiked ? .systemRed : .white
        
        // 이미지 로드
        loadImage(from: photo.urls.small)
    }
    
    private func loadImage(from urlString: String) {
        imageView.image = nil
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }.resume()
    }
    
    @objc private func likeButtonTapped() {
        guard let photoId = currentPhotoId else { return }
        
        let isCurrentlyLiked = UserDefaults.standard.bool(forKey: "liked_\(photoId)")
        let newLikedState = !isCurrentlyLiked
        
        UserDefaults.standard.set(newLikedState, forKey: "liked_\(photoId)")
        
        likeButton.isSelected = newLikedState
        likeButton.tintColor = newLikedState ? .systemRed : .white
        
        // 토스트 메시지
        if let viewController = findViewController() {
            let message = newLikedState ? "좋아요에 추가되었습니다" : "좋아요에서 제거되었습니다"
            showToast(message: message, in: viewController)
        }
    }
    
    private func findViewController() -> UIViewController? {
        var responder = self.next
        while responder != nil {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            responder = responder?.next
        }
        return nil
    }
    
    private func showToast(message: String, in viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        viewController.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            alert.dismiss(animated: true)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        currentPhotoId = nil
        likeButton.isSelected = false
        likeButton.tintColor = .white
    }
}
