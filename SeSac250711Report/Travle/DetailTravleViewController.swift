//
//  DetailTravleViewController.swift
//  SeSac250711Report
//
//  Created by 유태호 on 7/15/25.
//

import UIKit

class DetailTravleViewController: UIViewController {
    
    @IBOutlet var travleImageView: UIImageView!
    
    @IBOutlet var travleTitleLabel: UILabel!
    
    @IBOutlet var travleDescriptionLabel: UILabel!
    
    @IBOutlet var backButton: UIButton!
    
    
    // 전달받을 여행 데이터
    var travelData: Travel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 전달받은 데이터로 UI 설정
        configureUI()
    }
    
    func configureUI() {
        guard let travel = travelData else { return }
        
        // 네비게이션 타이틀 설정
        self.title = travel.title
        
        // 제목 설정
        travleTitleLabel.text = travel.title
        
        // 설명 설정
        travleDescriptionLabel.text = travel.description ?? "설명이 없습니다."
        
        // 이미지 설정
        if let imageURL = travel.travel_image {
            loadImageWithKingfisher(from: imageURL, into: travleImageView)
        } else {
            travleImageView.image = UIImage(systemName: "photo")
        }
        
        // 이미지뷰 스타일 설정
        travleImageView.contentMode = .scaleAspectFill
        travleImageView.clipsToBounds = true
        travleImageView.layer.cornerRadius = 12
        
        backButton.setTitle(NSLocalizedString("다른 관광지 보러 가기", comment: ""), for: .normal)
        backButton.layer.cornerRadius = 15
        backButton.layer.masksToBounds = true
        backButton.backgroundColor = .systemBlue
        backButton.setTitleColor(.white, for: .normal)
    }
    
    // Kingfisher로 이미지 로드하는 함수
    func loadImageWithKingfisher(from urlString: String, into imageView: UIImageView) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            imageView.image = UIImage(systemName: "photo")
            return
        }
        
        // Kingfisher를 사용하여 이미지 로드
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "photo"),
            options: [
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ]
        ) { result in
            switch result {
            case .success(let value):
                print("이미지 로딩 성공: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("이미지 로딩 실패: \(error)")
            }
        }
    }
    
    @IBAction func travleBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
}
