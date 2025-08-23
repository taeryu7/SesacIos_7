//
//  TamaDetailViewController.swift
//  Sesac20250822
//
//  Created by 유태호 on 8/22/25.
//

import UIKit
import SnapKit

class TamaDetailViewController: UIViewController {
    
    // UI 요소들
    let backgroundView = UIView()
    let containerView = UIView()
    let tamagochiImageView = UIImageView()
    let nameLabel = UILabel()
    let separatorLine = UIView()
    let descriptionLabel = UILabel()
    let startButton = UIButton()
    let cancelButton = UIButton()
    
    // 데이터
    var selectedTamagochiType: String?
    var onStartButtonTapped: ((String) -> Void)?
    var isChangingMode = false // 다마고치 변경 모드인지 여부
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        updateTamagochiInfo()
    }
    
    @objc private func startButtonTapped() {
        guard let selectedType = selectedTamagochiType else { return }
        dismiss(animated: true) {
            self.onStartButtonTapped?(selectedType)
        }
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func backgroundTapped() {
        dismiss(animated: true)
    }
    
    private func updateTamagochiInfo() {
        guard let tamagochiType = selectedTamagochiType else { return }
        
        tamagochiImageView.image = UIImage(named: tamagochiType) ?? UIImage(named: "noImage")
        
        // 다마고치 이름 설정
        let names: [String: String] = [
            "1-9": "따끔따끔 다마고치",
            "2-9": "방실방실 다마고치",
            "3-9": "반짝반짝 다마고치"
        ]
        nameLabel.text = names[tamagochiType] ?? "다마고치"
        
        // 다마고치별 설명 텍스트
        var descriptions: [String: String] = [:]
        
        if isChangingMode {
            // 다마고치 변경 모드일 때는 간단한 설명
            descriptions = [
                "1-9": "따끔따끔 다마고치로 변경하시겠습니까?\n현재 레벨과 데이터는 유지됩니다.",
                "2-9": "방실방실 다마고치로 변경하시겠습니까?\n현재 레벨과 데이터는 유지됩니다.",
                "3-9": "반짝반짝 다마고치로 변경하시겠습니까?\n현재 레벨과 데이터는 유지됩니다."
            ]
        } else {
            // 최초 선택 모드일 때는 자세한 설명
            descriptions = [
                "1-9": "따뜻한 마음을 가진 다마고치입니다.\n함께 즐거운 시간을 보내요!",
                "2-9": "활발하고 에너지 넘치는 다마고치입니다.\n매일 새로운 모험을 떠나요!",
                "3-9": "차분하고 지혜로운 다마고치입니다.\n깊은 대화를 나누어요!"
            ]
        }
        
        descriptionLabel.text = descriptions[tamagochiType] ?? "귀여운 다마고치입니다.\n잘 돌봐주세요!"
        
        // 버튼 텍스트 변경
        if isChangingMode {
            startButton.setTitle("변경하기", for: .normal)
        } else {
            startButton.setTitle("시작하기", for: .normal)
        }
    }
}

extension TamaDetailViewController {
    
    func configureHierarchy() {
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        containerView.addSubview(tamagochiImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(separatorLine)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(cancelButton)
        containerView.addSubview(startButton)
    }
    
    func configureLayout() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
        
        containerView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.equalTo(300)
            make.height.equalTo(450)
        }
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 0
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 8
        
        // 다마고치 이미지
        tamagochiImageView.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(30)
            make.centerX.equalTo(containerView)
            make.width.height.equalTo(150)
        }
        tamagochiImageView.contentMode = .scaleAspectFit
        tamagochiImageView.backgroundColor = .systemGray6
        tamagochiImageView.layer.cornerRadius = 75
        
        // 다마고치 이름
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(tamagochiImageView.snp.bottom).offset(20)
            make.leading.equalTo(containerView).offset(20)
            make.trailing.equalTo(containerView).offset(-20)
        }
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .label
        
        // 구분선
        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.leading.equalTo(containerView).offset(40)
            make.trailing.equalTo(containerView).offset(-40)
            make.height.equalTo(1)
        }
        separatorLine.backgroundColor = .systemGray4
        
        // 설명 라벨
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorLine.snp.bottom).offset(20)
            make.leading.equalTo(containerView).offset(20)
            make.trailing.equalTo(containerView).offset(-20)
            make.height.equalTo(60)
        }
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .label
        
        // 취소 버튼 (왼쪽)
        cancelButton.snp.makeConstraints { make in
            make.bottom.equalTo(containerView)
            make.leading.equalTo(containerView)
            make.trailing.equalTo(containerView.snp.centerX)
            make.height.equalTo(60)
        }
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.backgroundColor = .systemGray4
        cancelButton.setTitleColor(.label, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.layer.cornerRadius = 0
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        // 시작하기 버튼 (오른쪽)
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(containerView)
            make.leading.equalTo(containerView.snp.centerX)
            make.trailing.equalTo(containerView)
            make.height.equalTo(60)
        }
        startButton.setTitle("시작하기", for: .normal)
        startButton.backgroundColor = .systemBlue
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        startButton.layer.cornerRadius = 0
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
}

#Preview {
    let navController = UINavigationController(rootViewController: TamaDetailViewController())
    return navController
}
