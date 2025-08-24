//
//  TamaMainViewController.swift
//  20250708SeSacReport
//
//  Created by 유태호 on 7/9/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

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
    
    // ViewModel
    private let viewModel = TamaMainViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        configureHierarchy()
        configureUView()
        configureLayout()
        setupNavigationBar()
        bindViewModel()
        
        viewModel.viewDidLoadTrigger.onNext(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        
        viewModel.viewWillAppearTrigger.onNext(())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
    }
    
    // ViewModel 바인딩
    private func bindViewModel() {
        // Input 바인딩
        feedButton.rx.tap
            .withLatestFrom(feedTextField.rx.text.orEmpty)
            .bind(to: viewModel.feedButtonTap)
            .disposed(by: disposeBag)
        
        waterButton.rx.tap
            .withLatestFrom(waterTextField.rx.text.orEmpty)
            .bind(to: viewModel.waterButtonTap)
            .disposed(by: disposeBag)
        
        // Output 바인딩
        viewModel.tamagochiModel
            .drive(onNext: { [weak self] model in
                self?.updateUI(with: model)
            })
            .disposed(by: disposeBag)
        
        viewModel.bubbleMessage
            .drive(bubbleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.showAlert
            .drive(onNext: { [weak self] title, message in
                self?.showAlert(title: title, message: message)
            })
            .disposed(by: disposeBag)
        
        viewModel.clearTextField
            .drive(onNext: { [weak self] type in
                switch type {
                case .feed:
                    self?.feedTextField.text = ""
                case .water:
                    self?.waterTextField.text = ""
                }
            })
            .disposed(by: disposeBag)
    }
    
    // UI 업데이트
    private func updateUI(with model: TamagochiModel) {
        nameLabel.text = model.ownerName
        statusLabel.text = model.statusText
        navigationItem.title = model.navigationTitle
        
        // 다마고치 이미지 업데이트
        tamagochiImageView.image = UIImage(named: model.imageName) ?? UIImage(named: "noImage")
    }
    
    @objc private func profileButtonTapped() {
        let tamaSubVC = TamaSubViewController()
        navigationController?.pushViewController(tamaSubVC, animated: true)
    }
    
    @objc func unwindToTamaMain() {
        print("tamaMainViewController로 백")
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.systemGray
        ]
        
        // 프로필 아이콘 설정
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
