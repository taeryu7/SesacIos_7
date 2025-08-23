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
    
    // 데이터
    let activeTamagochiTypes = ["1-9", "2-9", "3-9"]
    let activeTamagochiNames = ["따끔따끔 다마고치", "방실방실 다마고치", "반짝반짝 다마고치"]
    let allSlots = Array(0..<15) // 3개 활성 + 12개 비활성
    var selectedTamagochiType: String?
    
    // 다마고치 변경 모드 관련
    var isChangingTamagochi = false // 다마고치 변경 모드인지 여부
    var onTamagochiChanged: (() -> Void)? // 다마고치 변경 완료 시 호출될 클로저
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureCollectionView()
        setupNavigationBar()
    }
    
    @objc private func topTamagochiTapped(_ sender: UITapGestureRecognizer) {
        guard let containerView = sender.view,
              let index = topStackView.arrangedSubviews.firstIndex(of: containerView) else { return }
        
        let selectedType = activeTamagochiTypes[index]
        showTamaDetailPopup(tamagochiType: selectedType)
    }
    
    @objc private func startButtonTapped() {
        guard let selectedType = selectedTamagochiType else {
            // 알림창 표시
            let alert = UIAlertController(title: "알림", message: "다마고치를 선택해주세요!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        // 선택된 다마고치 저장
        TamagochiUserDefaults.shared.saveSelectedTamagochiType(selectedType)
        
        if isChangingTamagochi {
            // 다마고치 변경 모드일 때
            onTamagochiChanged?()
        } else {
            // 최초 선택 모드일 때
            TamagochiUserDefaults.shared.setFirstLaunchCompleted()
            
            // 메인 화면으로 이동
            let mainVC = TamaMainViewController()
            let navController = UINavigationController(rootViewController: mainVC)
            
            if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = navController
                sceneDelegate.window?.makeKeyAndVisible()
            }
        }
    }
    
    
    private func showTamaDetailPopup(tamagochiType: String) {
        let detailVC = TamaDetailViewController()
        detailVC.selectedTamagochiType = tamagochiType
        detailVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        detailVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        // 다마고치 변경 모드 정보 전달
        detailVC.isChangingMode = isChangingTamagochi
        
        detailVC.onStartButtonTapped = { [weak self] (selectedType: String) in
            self?.selectedTamagochiType = selectedType
            self?.startButtonTapped()
        }
        
        present(detailVC, animated: true)
    }
    
    private func setupNavigationBar() {
        if isChangingTamagochi {
            navigationItem.title = "다마고치 변경"
        } else {
            navigationItem.title = "다마고치 선택"
        }
        navigationController?.navigationBar.tintColor = UIColor.label
    }
    
    private func configureLabel(_ label: UILabel, text: String) {
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        
        // 테두리 효과
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.shadowOpacity = 0.3
        label.layer.shadowRadius = 1
    }
}

extension TamaSelectViewController {
    
    func configureHierarchy() {
        view.addSubview(topStackView)
        view.addSubview(collectionView)
    }
    
    func configureLayout() {
        view.backgroundColor = .systemBackground
        
        // 상단 3개 활성 다마고치
        topStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.height.equalTo(130) // 라벨 공간을 위해 높이 증가
        }
        topStackView.axis = .horizontal
        topStackView.distribution = .fillEqually
        topStackView.spacing = 20
        
        // 3개의 활성 다마고치 컨테이너 뷰
        for (index, tamagochiType) in activeTamagochiTypes.enumerated() {
            // 컨테이너 뷰 생성
            let containerView = UIView()
            containerView.isUserInteractionEnabled = true
            
            // 이미지뷰 생성
            let imageView = UIImageView()
            imageView.image = UIImage(named: tamagochiType) ?? UIImage(named: "noImage")
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = .systemGray6
            imageView.layer.cornerRadius = 50
            imageView.clipsToBounds = true
            
            // 라벨 생성
            let label = UILabel()
            configureLabel(label, text: activeTamagochiNames[index])
            
            // 컨테이너에 이미지뷰와 라벨 추가
            containerView.addSubview(imageView)
            containerView.addSubview(label)
            
            // 오토레이아웃 설정
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
            
            // 탭 제스처 추가
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(topTamagochiTapped(_:)))
            containerView.addGestureRecognizer(tapGesture)
            
            topStackView.addArrangedSubview(containerView)
        }
        
        // 컬렉션뷰
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(TamaSlotCollectionViewCell.self, forCellWithReuseIdentifier: "TamaSlotCell")
        
        // 플로우 레이아웃 설정
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
}

// UICollectionView DataSource & Delegate
extension TamaSelectViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24 // 1-2~1-9, 2-2~2-9, 3-2~3-9 이 24개
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TamaSlotCell", for: indexPath) as! TamaSlotCollectionViewCell
        
        // 24개 셀을 순차적으로 배치: 1-2, 2-2, 3-2, 1-3, 2-3, 3-3... 1-9, 2-9, 3-9
        let level = (indexPath.row % 3) + 1  // 1, 2, 3 순환
        let stage = (indexPath.row / 3) + 2  // 2부터 시작해서 9까지
        
        let imageName = "\(level)-\(stage)"
        cell.configure(isActive: false, imageName: imageName)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let sectionInset: CGFloat = 20
        let availableWidth = collectionView.frame.width - (sectionInset * 2) - (spacing * 2) // 양쪽 여백 + 2개 간격
        let cellWidth = availableWidth / 3
        return CGSize(width: cellWidth, height: cellWidth + 30) // 라벨 공간을 위해 높이 증가
    }
}

// TamaSlotCollectionViewCell
class TamaSlotCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let lockImageView = UIImageView()
    let statusLabel = UILabel()
    private var overlayView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(lockImageView)
        contentView.addSubview(statusLabel)
        
        // 이미지뷰는 상단에 정사각형으로 배치
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(imageView.snp.width) // 정사각형
        }
        
        lockImageView.snp.makeConstraints { make in
            make.center.equalTo(imageView)
            make.width.height.equalTo(30)
        }
        
        // 라벨은 이미지뷰 아래에 배치
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.leading.trailing.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
        // 기본 설정
        imageView.backgroundColor = .systemGray5
        imageView.contentMode = .scaleAspectFit
        
        lockImageView.image = UIImage(systemName: "lock.fill")
        lockImageView.tintColor = .systemGray3
        
        // 라벨 기본 설정
        statusLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        statusLabel.textColor = UIColor.darkGray
        statusLabel.textAlignment = .center
        
        // 라벨 테두리 효과
        statusLabel.layer.shadowColor = UIColor.black.cgColor
        statusLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        statusLabel.layer.shadowOpacity = 0.3
        statusLabel.layer.shadowRadius = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cornerRadius = imageView.frame.width / 2
        imageView.layer.cornerRadius = cornerRadius
        
        overlayView?.layer.cornerRadius = cornerRadius
    }
    
    func configure(isActive: Bool, imageName: String?) {
        // 기존 오버레이 제거
        overlayView?.removeFromSuperview()
        overlayView = nil
        
        if isActive, let imageName = imageName {
            imageView.image = UIImage(named: imageName) ?? UIImage(named: "noImage")
            imageView.backgroundColor = .systemGray6
            lockImageView.isHidden = true
            statusLabel.text = ""
        } else if let imageName = imageName {
            // 비활성 상태이지만 이미지가 있는 경우
            imageView.image = UIImage(named: imageName) ?? UIImage(named: "noImage")
            imageView.backgroundColor = .systemGray5
            lockImageView.isHidden = true
            statusLabel.text = "준비중이에요"
            
            // 회색 오버레이 추가
            let newOverlayView = UIView()
            newOverlayView.backgroundColor = UIColor.systemGray4.withAlphaComponent(0.7)
            imageView.addSubview(newOverlayView)
            newOverlayView.snp.makeConstraints { make in
                make.edges.equalTo(imageView)
            }
            overlayView = newOverlayView
            
            /// layoutSubviews에서 cornerRadius가 설정되도록 강제 호출
            /// 해당부분이 됐다 안됐다 하는 이슈발생, 메모리문제인지 뷰 호출쪽 문제인지 모르겠음
            setNeedsLayout()
        } else {
            // 완전 비활성 상태 (잠금 아이콘)
            imageView.image = nil
            imageView.backgroundColor = .systemGray5
            lockImageView.isHidden = false
            statusLabel.text = "준비중이에요"
        }
    }
}

#Preview {
    let navController = UINavigationController(rootViewController: TamaSelectViewController())
    return navController
}
