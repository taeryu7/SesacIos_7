//
//  CityTableViewCell.swift
//  SeSac250711Report
//
//  Created by 유태호 on 7/15/25.
//₩

import UIKit
import Kingfisher

class CityTableViewCell: UITableViewCell {
    
    @IBOutlet var cityImageView: UIImageView!
    
    @IBOutlet var cityNameKorLabel: UILabel!
    
    @IBOutlet var cityNameEngLabel: UILabel!
    
    @IBOutlet var cityExplainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI() {
        // 이미지뷰 설정
        cityImageView.contentMode = .scaleAspectFill
        cityImageView.clipsToBounds = true
        cityImageView.layer.cornerRadius = 12
        cityImageView.backgroundColor = UIColor.lightGray
        
        // 한글 도시명 라벨 설정 (검정색)
        cityNameKorLabel.font = UIFont.boldSystemFont(ofSize: 18)
        cityNameKorLabel.textColor = .white
        cityNameKorLabel.numberOfLines = 1
        
        // 영문 도시명 라벨 설정 (검정색)
        cityNameEngLabel.font = UIFont.systemFont(ofSize: 14)
        cityNameEngLabel.textColor = .white
        cityNameEngLabel.numberOfLines = 1
        
        // 설명 라벨 설정 (검정색)
        cityExplainLabel.font = UIFont.systemFont(ofSize: 12)
        cityExplainLabel.textColor = .white
        cityExplainLabel.numberOfLines = 2
        
        // 셀 선택 스타일
        selectionStyle = .default
    }
    
    func configure(with city: City) {
        // | 구분자를 추가한 도시명 표시
        cityNameKorLabel.text = "\(city.city_name) | \(city.city_english_name)"
        
        // 영문 라벨은 비워두거나 다른 용도로 사용
        cityNameEngLabel.text = ""
        
        cityExplainLabel.text = city.city_explain
        
        // 이미지 로딩
        loadCityImage(from: city.city_image)
    }
    
    private func loadCityImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            cityImageView.image = UIImage(systemName: "photo")
            return
        }
        
        let processor = DownsamplingImageProcessor(size: CGSize(width: 120, height: 120))
        
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
