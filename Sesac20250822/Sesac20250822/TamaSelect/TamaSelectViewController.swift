//
//  TamaSelectViewController.swift
//  Sesac20250822
//
//  Created by 유태호 on 8/22/25.
//

import UIKit
import SnapKit

class TamaSelectViewController: UIViewController {
    
    // UI 요소들
    let topStackView = UIStackView()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    // ViewModel
    private var viewModel: TamaSelectViewModel?
    
    // 데이터
    var selectModel: TamaSelectModel?
    
    // 다마고치 변경 모드 관련
    var isChangingTamagochi = false // 다마고치 변경 모드인지 여부
    var onTamagochiChanged: (() -> Void)? // 다마고치 변경 완료 시 호출될 클로저
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        configureHierarchy()
        configureLayout()
        configureCollectionView()
        setupNavigationBar()
        bindViewModel()
        
        viewModel?.viewDidLoad()
    }
    
    // ViewModel 설정
    private func setupViewModel() {
        viewModel = TamaSelectViewModel(
            isChangingMode: isChangingTamagochi,
            onTamagochiChanged: onTamagochiChanged
        )
    }
    
    // ViewModel 바인딩
    private func bindViewModel() {
        viewModel?.selectModel = { [weak self] model in
            DispatchQueue.main.async {
                self?.updateUI(with: model)
            }
        }
        
        viewModel?.showTamaDetailPopup = { [weak self] tamagochiType, isChangingMode in
            DispatchQueue.main.async {
                self?.showTamaDetailPopup(tamagochiType: tamagochiType, isChangingMode: isChangingMode)
            }
        }
        
        viewModel?.showAlert = { [weak self] title, message in
            DispatchQueue.main.async {
                self?.showAlert(title: title, message: message)
            }
        }
        
        viewModel?.navigateToMain = { [weak self] in
            DispatchQueue.main.async {
                self?.navigateToMainScreen()
            }
        }
        
        viewModel?.dismissToMain = { [weak self] in
            DispatchQueue.main.async {
                // 이미 onTamagochiChanged 클로저에서 처리됨
            }
        }
    }
    
    // UI 업데이트
    private func updateUI(with model: TamaSelectModel) {
        self.selectModel = model
        navigationItem.title = model.navigationTitle
        setupTopStackView(with: model.activeSlots)
        collectionView.reloadData()
    }
    
    @objc func activeTamagochiTapped(_ sender: UITapGestureRecognizer) {
        guard let containerView = sender.view,
              let index = topStackView.arrangedSubviews.firstIndex(of: containerView) else { return }
        
        viewModel?.activeTamagochiTapped(at: index)
    }
    
    private func showTamaDetailPopup(tamagochiType: String, isChangingMode: Bool) {
        let detailVC = TamaDetailViewController()
        detailVC.selectedTamagochiType = tamagochiType
        detailVC.isChangingMode = isChangingMode
        detailVC.modalPresentationStyle = .overFullScreen
        detailVC.modalTransitionStyle = .crossDissolve
        
        detailVC.onStartButtonTapped = { [weak self] selectedType in
            self?.viewModel?.setSelectedTamagochi(selectedType)
        }
        
        present(detailVC, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private func navigateToMainScreen() {
        let mainVC = TamaMainViewController()
        let navController = UINavigationController(rootViewController: mainVC)
        
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = navController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
}

#Preview {
    let navController = UINavigationController(rootViewController: TamaSelectViewController())
    return navController
}
