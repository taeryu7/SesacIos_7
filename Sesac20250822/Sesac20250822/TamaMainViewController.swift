//
//  TamaMainViewController.swift
//  20250708SeSacReport
//
//  Created by 유태호 on 7/9/25.
//

import UIKit
import SnapKit

class TamaMainViewController: UIViewController {
    
    // UI 요소들
    let navigationSeparatorLine = UIView()
    let bubbleImageView = UIImageView()
    let bubbleLabel = UILabel()
    let tamagochiImageView = UIImageView()
    let nameLabel = UILabel()
    let statusLabel = UILabel()
    let feedTextField = UITextField()
    let feedSeparatorLine = UIView()
    let feedButton = UIButton()
    let waterTextField = UITextField()
    let waterSeparatorLine = UIView()
    let waterButton = UIButton()
    
    // 다마고치 상태
    var currentLevel = 1
    var currentStage = 1
    var riceCount = 5
    var waterCount = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        configureHierarchy()
        configureUView()
        configureLayout()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
    }
    
    @objc private func feedButtonTapped() {
        print("밥먹기 버튼 탭됨")
        riceCount += 1
        updateTamagochiStatus()
    }
    
    @objc private func waterButtonTapped() {
        print("물먹기 버튼 탭됨")
        waterCount += 1
        updateTamagochiStatus()
    }
    
    private func updateTamagochiStatus() {
        // 간단한 성장 로직
        if riceCount >= 5 && waterCount >= 3 {
            currentStage += 1
            riceCount = 0
            waterCount = 0
            
            if currentStage > 9 {
                currentStage = 1
                currentLevel += 1
                if currentLevel > 3 {
                    currentLevel = 1
                }
            }
        }
        
        updateTamagochiImage()
        updateStatusLabel()
        
        // 말풍선 텍스트
        let messages = ["고마워요!", "맛있어요~", "기분이 좋아졌어요!", "더 자라고 있어요!"]
        bubbleLabel.text = messages.randomElement()
    }
    
    @objc func unwindToTamaMain() {
        print("tamaMainViewController로 백")
    }
}

extension TamaMainViewController {
    
    func configureHierarchy() {
        view.addSubview(navigationSeparatorLine)
        view.addSubview(bubbleImageView)
        view.addSubview(bubbleLabel)
        view.addSubview(tamagochiImageView)
        view.addSubview(nameLabel)
        view.addSubview(statusLabel)
        view.addSubview(feedTextField)
        view.addSubview(feedSeparatorLine)
        view.addSubview(feedButton)
        view.addSubview(waterTextField)
        view.addSubview(waterSeparatorLine)
        view.addSubview(waterButton)
    }
    
    func configureUView() {
        // 네비게이션 구분선
        navigationSeparatorLine.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        // 말풍선 이미지뷰
        bubbleImageView.snp.makeConstraints { make in
            make.top.equalTo(navigationSeparatorLine.snp.bottom).offset(30)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
            make.height.equalTo(100)
        }
        
        // 말풍선 텍스트
        bubbleLabel.snp.makeConstraints { make in
            make.center.equalTo(bubbleImageView)
            make.width.equalTo(bubbleImageView).offset(-40)
        }
        
        // 다마고치 이미지
        tamagochiImageView.snp.makeConstraints { make in
            make.top.equalTo(bubbleImageView.snp.bottom).offset(30)
            make.centerX.equalTo(view)
            make.width.height.equalTo(200)
        }
        
        // 이름 라벨 (테두리 추가)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(tamagochiImageView.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.height.equalTo(40)
        }
        
        // 상태 라벨 (레벨 · 밥알 · 물방울)
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.centerX.equalTo(view)
        }
        
        // 밥 텍스트필드
        feedTextField.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(30)
            make.centerX.equalTo(tamagochiImageView)
            make.leading.equalTo(tamagochiImageView.snp.leading)
            make.trailing.equalTo(feedButton.snp.leading).offset(-10)
            make.height.equalTo(40)
        }
        
        // 밥 구분선
        feedSeparatorLine.snp.makeConstraints { make in
            make.top.equalTo(feedTextField.snp.bottom)
            make.leading.trailing.equalTo(feedTextField)
            make.height.equalTo(1)
        }
        
        // 밥먹기 버튼
        feedButton.snp.makeConstraints { make in
            make.centerY.equalTo(feedTextField)
            make.trailing.equalTo(tamagochiImageView.snp.trailing)
            make.width.equalTo(70)
            make.height.equalTo(40)
        }
        
        // 물 텍스트필드
        waterTextField.snp.makeConstraints { make in
            make.top.equalTo(feedSeparatorLine.snp.bottom).offset(20)
            make.centerX.equalTo(tamagochiImageView)
            make.leading.equalTo(tamagochiImageView.snp.leading)
            make.trailing.equalTo(waterButton.snp.leading).offset(-10)
            make.height.equalTo(40)
        }
        
        // 물 구분선
        waterSeparatorLine.snp.makeConstraints { make in
            make.top.equalTo(waterTextField.snp.bottom)
            make.leading.trailing.equalTo(waterTextField)
            make.height.equalTo(1)
        }
        
        // 물먹기 버튼
        waterButton.snp.makeConstraints { make in
            make.centerY.equalTo(waterTextField)
            make.trailing.equalTo(tamagochiImageView.snp.trailing)
            make.width.equalTo(70)
            make.height.equalTo(40)
        }
    }
    
    func configureLayout() {
        view.backgroundColor = .systemBackground
        
        // 네비게이션 구분선 설정
        navigationSeparatorLine.backgroundColor = .systemGray4
        
        // 말풍선 설정
        bubbleImageView.image = UIImage(named: "bubble")
        bubbleImageView.contentMode = .scaleAspectFit
        
        // 말풍선 텍스트
        bubbleLabel.text = "안녕하세요! 저를 키워주세요~"
        bubbleLabel.textAlignment = .center
        bubbleLabel.font = UIFont.systemFont(ofSize: 14)
        bubbleLabel.numberOfLines = 0
        bubbleLabel.textColor = .black
        
        // 다마고치 이미지 설정
        updateTamagochiImage()
        tamagochiImageView.contentMode = .scaleAspectFit
        tamagochiImageView.layer.cornerRadius = 100
        tamagochiImageView.backgroundColor = .systemGray6
        
        // 이름 라벨 (테두리 추가)
        nameLabel.text = "대장 다마고치"
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .black
        nameLabel.layer.borderWidth = 1
        nameLabel.layer.borderColor = UIColor.systemGray4.cgColor
        nameLabel.layer.cornerRadius = 8
        
        // 상태 라벨 (레벨 · 밥알 · 물방울)
        updateStatusLabel()
        statusLabel.font = UIFont.systemFont(ofSize: 14)
        statusLabel.textAlignment = .center
        statusLabel.textColor = .systemGray
        
        // 밥 텍스트필드
        feedTextField.placeholder = "밥주세용"
        feedTextField.font = UIFont.systemFont(ofSize: 16)
        feedTextField.textColor = .black
        feedTextField.textAlignment = .center
        feedTextField.borderStyle = .none
        
        // 밥 구분선
        feedSeparatorLine.backgroundColor = .black
        
        // 밥먹기 버튼
        feedButton.setTitle("  밥먹기", for: .normal)
        feedButton.setImage(UIImage(systemName: "fork.knife"), for: .normal)
        feedButton.backgroundColor = .systemOrange
        feedButton.setTitleColor(.white, for: .normal)
        feedButton.tintColor = .white
        feedButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        feedButton.layer.cornerRadius = 8
        feedButton.addTarget(self, action: #selector(feedButtonTapped), for: .touchUpInside)
        
        // 물 텍스트필드
        waterTextField.placeholder = "물주세용"
        waterTextField.font = UIFont.systemFont(ofSize: 16)
        waterTextField.textColor = .black
        waterTextField.textAlignment = .center
        waterTextField.borderStyle = .none
        
        // 물 구분선
        waterSeparatorLine.backgroundColor = .black
        
        // 물먹기 버튼
        waterButton.setTitle("  물먹기", for: .normal)
        waterButton.setImage(UIImage(systemName: "drop.fill"), for: .normal)
        waterButton.backgroundColor = .systemBlue
        waterButton.setTitleColor(.white, for: .normal)
        waterButton.tintColor = .white
        waterButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        waterButton.layer.cornerRadius = 8
        waterButton.addTarget(self, action: #selector(waterButtonTapped), for: .touchUpInside)
    }
    
    private func updateStatusLabel() {
        statusLabel.text = "LV.\(currentLevel) · 밥알 \(riceCount)개 · 물방울 \(waterCount)개"
    }
    
    private func updateTamagochiImage() {
        let imageName = "\(currentLevel)-\(currentStage)"
        tamagochiImageView.image = UIImage(named: imageName) ?? UIImage(named: "noImage")
    }
    
    @objc private func profileButtonTapped() {
        let tamaSubVC = TamaSubViewController()
        navigationController?.pushViewController(tamaSubVC, animated: true)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "00님의 다마고치"
        
        // 네비게이션 타이틀
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.systemGray
        ]
        
        // 프로필 아이콘
        let profileBarButton = UIBarButtonItem(
            image: UIImage(systemName: "person.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(profileButtonTapped)
        )
        profileBarButton.tintColor = UIColor.systemGray
        navigationItem.rightBarButtonItem = profileBarButton
    }
}

#Preview {
    let navController = UINavigationController(rootViewController: TamaMainViewController())
    return navController
}
