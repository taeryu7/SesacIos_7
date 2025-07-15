//
//  ImageManager.swift
//  SeSac250711Report
//
//  Created by 유태호 on 7/15/25.
//

import UIKit
import Kingfisher

final class ImageManager {
    
    static let shared = ImageManager()
    private init() {}
    
    // 테이블뷰 셀용 이미지 로딩
    @MainActor
    func loadImageForCell(from urlString: String, into imageView: UIImageView) {
        guard let url = URL(string: urlString) else {
            imageView.image = UIImage(systemName: "photo")
            return
        }
        
        // 이미지뷰 스타일 설정
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        
        // 다운샘플링 + 백그라운드 디코딩으로 성능 최적화
        let processor = DownsamplingImageProcessor(size: CGSize(width: 120, height: 120))
        
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "photo"),
            options: [
                .processor(processor),
                .backgroundDecode,
                .cacheOriginalImage
            ]
        )
    }
    
    // 상세화면용 이미지 로딩
    @MainActor
    func loadImageForDetail(from urlString: String, into imageView: UIImageView) {
        guard let url = URL(string: urlString) else {
            imageView.image = UIImage(systemName: "photo")
            return
        }
        
        // 이미지뷰 스타일 설정
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        
        // 상세화면은 조금 더 큰 크기로 다운샘플링
        let processor = DownsamplingImageProcessor(size: CGSize(width: 300, height: 200))
        
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "photo"),
            options: [
                .processor(processor),
                .backgroundDecode,
                .cacheOriginalImage
            ]
        )
    }
}
