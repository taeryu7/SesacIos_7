//
//  TamaSelectViewController.swift
//  Sesac20250822
//
//  Created by 유태호 on 8/22/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TamaSelectViewController: UIViewController {
    
    let topStackView = UIStackView()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private var viewModel: TamaSelectViewModel?
    private let disposeBag = DisposeBag()
    
    var selectModel: TamaSelectModel?
    
    var isChangingTamagochi = false
    var onTamagochiChanged: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        configureHierarchy()
        configureLayout()
        configureCollectionView()
        setupNavigationBar()
        bindViewModel()
        
        viewModel?.viewDidLoadTrigger.onNext(())
    }
    
    private func setupViewModel() {
        viewModel = TamaSelectViewModel(
            isChangingMode: isChangingTamagochi,
            onTamagochiChanged: onTamagochiChanged
        )
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.selectModel
            .drive(onNext: { [weak self] model in
                self?.updateUI(with: model)
            })
            .disposed(by: disposeBag)
        
        viewModel.showTamaDetailPopup
            .drive(onNext: { [weak self] tamagochiType, isChangingMode in
                self?.showTamaDetailPopup(tamagochiType: tamagochiType, isChangingMode: isChangingMode)
            })
            .disposed(by: disposeBag)
        
        viewModel.showAlert
            .drive(onNext: { [weak self] title, message in
                self?.showAlert(title: title, message: message)
            })
            .disposed(by: disposeBag)
        
        viewModel.navigateToMain
            .drive(onNext: { [weak self] in
                self?.navigateToMainScreen()
            })
            .disposed(by: disposeBag)
        
        viewModel.dismissToMain
            .drive(onNext: { [weak self] in
                
            })
            .disposed(by: disposeBag)
    }
    
    private func updateUI(with model: TamaSelectModel) {
        self.selectModel = model
        navigationItem.title = model.navigationTitle
        setupTopStackViewRx(with: model.activeSlots)
        collectionView.reloadData()
    }
    
    private func setupTopStackViewRx(with activeSlots: [ActiveTamagochiSlot]) {
        topStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, slot) in activeSlots.enumerated() {
            let containerView = createActiveTamagochiContainerRx(
                imageName: slot.imageName,
                name: slot.name,
                index: index
            )
            topStackView.addArrangedSubview(containerView)
        }
    }
    
    private func createActiveTamagochiContainerRx(imageName: String, name: String, index: Int) -> UIView {
        let containerView = UIView()
        containerView.isUserInteractionEnabled = true
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName) ?? UIImage(named: "noImage")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        
        let label = UILabel()
        label.text = name
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.shadowOpacity = 0.3
        label.layer.shadowRadius = 1
        
        containerView.addSubview(imageView)
        containerView.addSubview(label)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(containerView)
            make.leading.trailing.equalTo(containerView)
            make.height.equalTo(100)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.leading.trailing.equalTo(containerView)
            make.bottom.equalTo(containerView)
        }
        
        let tapGesture = UITapGestureRecognizer()
        containerView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .map { _ in index }
            .bind(to: viewModel?.activeTamagochiTap ?? PublishSubject<Int>())
            .disposed(by: disposeBag)
        
        return containerView
    }
    
    private func showTamaDetailPopup(tamagochiType: String, isChangingMode: Bool) {
        let detailVC = TamaDetailViewController()
        detailVC.selectedTamagochiType = tamagochiType
        detailVC.isChangingMode = isChangingMode
        detailVC.modalPresentationStyle = .overFullScreen
        detailVC.modalTransitionStyle = .crossDissolve
        
        detailVC.onStartButtonTapped = { [weak self] selectedType in
            self?.viewModel?.selectedTamagochi.onNext(selectedType)
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
