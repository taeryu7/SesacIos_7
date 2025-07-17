//
//  CityCollectionViewCell.swift
//  SeSac250711Report
//
//  Created by 유태호 on 7/17/25.
//

import UIKit
import Kingfisher

class CityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var cityImageView: UIImageView!
    
    @IBOutlet var cityNameKorLabel: UILabel!
    
    @IBOutlet var cityNameEngLabel: UILabel!
    
    @IBOutlet var cityExplainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI() {
        // 셀 전체 설정
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor.systemBackground
        
        // 그림자 효과 (선택사항)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
        
        // 이미지뷰 설정
        cityImageView.contentMode = .scaleAspectFill
        cityImageView.clipsToBounds = true
        cityImageView.layer.cornerRadius = 8
        cityImageView.backgroundColor = UIColor.lightGray
        
        // 한글 도시명 라벨 설정
        cityNameKorLabel.font = UIFont.boldSystemFont(ofSize: 14)
        cityNameKorLabel.textColor = .label
        cityNameKorLabel.numberOfLines = 1
        cityNameKorLabel.textAlignment = .center
        
        // 영문 도시명 라벨 설정
        cityNameEngLabel.font = UIFont.systemFont(ofSize: 14)
        cityNameEngLabel.textColor = .label
        cityNameEngLabel.numberOfLines = 1
        cityNameEngLabel.textAlignment = .center
        
        // 설명 라벨 설정
        cityExplainLabel.font = UIFont.systemFont(ofSize: 12)
        cityExplainLabel.textColor = .tertiaryLabel
        cityExplainLabel.numberOfLines = 2
        cityExplainLabel.textAlignment = .center
        ///numberOfLines 미적용현상발생, 멘토님께 여쭤볼것
        cityExplainLabel.numberOfLines = 0
    }
    
    func configure(with city: City) {
        
        let combinedCityName = "\(city.city_name) | \(city.city_english_name)"
        cityNameKorLabel.text = combinedCityName
        
        cityNameEngLabel.text = ""
        
        cityExplainLabel.text = city.city_explain
        loadCityImage(from: city.city_image)
    }
    
    // 이미지 로딩 함수
    private func loadCityImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            cityImageView.image = UIImage(systemName: "photo")
            return
        }
        
        // 컬렉션뷰 셀 크기에 맞는 이미지 프로세서
        let processor = DownsamplingImageProcessor(size: CGSize(width: 150, height: 150))
        
        cityImageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "photo"),
            options: [
                .processor(processor),
                .backgroundDecode,
                .cacheOriginalImage,
                .transition(.fade(0.2))
            ]
        ) { result in
            switch result {
            case .success(_):
                print("이미지 로딩 성공: \(urlString)")
            case .failure(let error):
                print("이미지 로딩 실패: \(error)")
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cityImageView.kf.cancelDownloadTask()
        cityImageView.image = UIImage(systemName: "photo")
        cityNameKorLabel.text = nil
        cityNameEngLabel.text = nil
        cityExplainLabel.text = nil
    }
}
