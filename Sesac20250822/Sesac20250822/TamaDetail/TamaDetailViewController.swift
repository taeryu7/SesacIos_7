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
    
    // ViewModel
    private var viewModel: TamaDetailViewModel?
    
    // 데이터
    var selectedTamagochiType: String?
    var onStartButtonTapped: ((String) -> Void)?
    var isChangingMode = false // 다마고치 변경 모드인지 여부
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        configureHierarchy()
        configureLayout()
        bindViewModel()
        
        viewModel?.viewDidLoad()
    }
    
    // ViewModel 설정
    private func setupViewModel() {
        guard let selectedType = selectedTamagochiType else { return }
        viewModel = TamaDetailViewModel(
            selectedTamagochiType: selectedType,
            isChangingMode: isChangingMode,
            onStartButtonTapped: onStartButtonTapped
        )
    }
    
    // ViewModel 바인딩
    private func bindViewModel() {
        viewModel?.detailModel = { [weak self] model in
            DispatchQueue.main.async {
                self?.updateUI(with: model)
            }
        }
        
        viewModel?.dismissView = { [weak self] in
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
            }
        }
        
        viewModel?.startAction = { [weak self] selectedType in
            self?.onStartButtonTapped?(selectedType)
        }
    }
    
    // UI 업데이트
    private func updateUI(with model: TamaDetailModel) {
        tamagochiImageView.image = UIImage(named: model.imageName) ?? UIImage(named: "noImage")
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        startButton.setTitle(model.buttonTitle, for: .normal)
    }
    
    @objc private func startButtonTapped() {
        viewModel?.startButtonTapped()
    }
    
    @objc private func cancelButtonTapped() {
        viewModel?.cancelButtonTapped()
    }
    
    @objc private func backgroundTapped() {
        viewModel?.backgroundTapped()
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
