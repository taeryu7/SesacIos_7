//
//  TopicPhotoCell.swift
//  Sesac250814
//
//  Created by 유태호 on 8/15/25.
//

import UIKit
import SnapKit

class TopicPhotoCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let likesLabel = UILabel()
    
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
        
        likesLabel.font = .systemFont(ofSize: 12, weight: .medium)
        likesLabel.textColor = .white
        likesLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        likesLabel.layer.cornerRadius = 8
        likesLabel.textAlignment = .center
        likesLabel.clipsToBounds = true
    }
    
    private func setupLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(likesLabel)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        likesLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(8)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(40)
        }
    }
    
    func configure(with photo: Photo) {
        // 좋아요 수 표시 (콤마 포함)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let likesText = formatter.string(from: NSNumber(value: photo.likes)) ?? "\(photo.likes)"
        likesLabel.text = "⭐ \(likesText)"
        
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
