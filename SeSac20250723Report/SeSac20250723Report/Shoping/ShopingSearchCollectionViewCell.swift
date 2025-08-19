//
//  ShopingSearchCollectionViewCell.swift
//  SeSac20250723Report
//
//  Created by 유태호 on 7/26/25.
//

import UIKit
import SnapKit

class ShopingSearchCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ShopingSearchCollectionViewCell"
    
    let productImageView = UIImageView()      // 상품 이미지
    let titleLabel = UILabel()                // 상품명
    let mallNameLabel = UILabel()             // 쇼핑몰명
    let priceLabel = UILabel()                // 가격
    let favoriteButton = UIButton()           // 찜하기 버튼
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureUView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShopingSearchCollectionViewCell {
    
    func configureHierarchy() {
        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(favoriteButton)
    }
    
    func configureUView() {
        productImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(150)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalTo(productImageView).offset(-10)
            make.top.equalTo(productImageView).offset(10)
            make.width.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(contentView).inset(8)
            make.height.equalTo(35)
        }
        
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(contentView).inset(8)
            make.height.equalTo(15)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(contentView).inset(8)
            make.height.equalTo(20)
        }
    }
    
    func configureLayout() {
        backgroundColor = .black
        layer.cornerRadius = 12
        clipsToBounds = true
        
        // 상품 이미지뷰 설정
        productImageView.backgroundColor = .systemGray6
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        
        // 제목 라벨 설정
        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        
        // 쇼핑몰 라벨 설정
        mallNameLabel.font = .systemFont(ofSize: 11)
        mallNameLabel.textColor = .systemGray
        
        // 가격 라벨 설정
        priceLabel.font = .systemFont(ofSize: 15, weight: .bold)
        priceLabel.textColor = .white
        
        // 찜하기 버튼 설정
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .white
        favoriteButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        favoriteButton.layer.cornerRadius = 15
    }
    
    func configure(with item: ShoppingItem) {
        // HTML 태그 제거
        //
        let cleanTitle = item.title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        titleLabel.text = cleanTitle
        mallNameLabel.text = item.mallName
        
        // 가격 포맷팅
        if let price = Int(item.lprice) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            priceLabel.text = "\(formatter.string(from: NSNumber(value: price)) ?? "")원"
        } else {
            priceLabel.text = "\(item.lprice)원"
        }
        
        // 이미지 로드
        loadImage(from: item.image)
    }
    
    func loadImage(from urlString: String) {
        // 기존 이미지 초기화
        productImageView.image = nil
        
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.productImageView.image = image
                }
            }
        }
    }
}
