//
//  TamaSelectViewController+UI.swift
//  Sesac20250822
//
//  Created by 유태호 on 8/23/25.
//

import UIKit
import SnapKit

// UI 구성 관련
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
        
        // 컬렉션뷰
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    func setupTopStackView(with activeSlots: [ActiveTamagochiSlot]) {
        // 기존 서브뷰들 제거
        topStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 활성 다마고치 컨테이너 뷰들 생성
        for (index, slot) in activeSlots.enumerated() {
            let containerView = createActiveTamagochiContainer(
                imageName: slot.imageName,
                name: slot.name,
                index: index
            )
            topStackView.addArrangedSubview(containerView)
        }
    }
    
    private func createActiveTamagochiContainer(imageName: String, name: String, index: Int) -> UIView {
        // 컨테이너 뷰 생성
        let containerView = UIView()
        containerView.isUserInteractionEnabled = true
        
        // 이미지뷰 생성
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName) ?? UIImage(named: "noImage")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        
        // 라벨 생성
        let label = UILabel()
        configureActiveSlotLabel(label, text: name)
        
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
        
        
        return containerView
    }
    
    private func configureActiveSlotLabel(_ label: UILabel, text: String) {
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
    
    func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = UIColor.label
    }
}

// 컬렉션뷰 관련
extension TamaSelectViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectModel?.collectionSlots.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TamaSlotCell", for: indexPath) as! TamaSlotCollectionViewCell
        
        guard let slot = selectModel?.collectionSlots[indexPath.row] else { return cell }
        
        cell.configure(
            isActive: slot.isActive,
            imageName: slot.imageName,
            statusText: slot.statusText
        )
        
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

// 커스텀 컬렉션뷰 셀
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
    
    func configure(isActive: Bool, imageName: String, statusText: String) {
        // 기존 오버레이 제거
        overlayView?.removeFromSuperview()
        overlayView = nil
        
        if isActive {
            imageView.image = UIImage(named: imageName) ?? UIImage(named: "noImage")
            imageView.backgroundColor = .systemGray6
            lockImageView.isHidden = true
            statusLabel.text = ""
        } else {
            // 비활성 상태
            imageView.image = UIImage(named: imageName) ?? UIImage(named: "noImage")
            imageView.backgroundColor = .systemGray5
            lockImageView.isHidden = true
            statusLabel.text = statusText
            
            // 회색 오버레이 추가
            let newOverlayView = UIView()
            newOverlayView.backgroundColor = UIColor.systemGray4.withAlphaComponent(0.7)
            imageView.addSubview(newOverlayView)
            newOverlayView.snp.makeConstraints { make in
                make.edges.equalTo(imageView)
            }
            overlayView = newOverlayView
            
            // layoutSubviews에서 cornerRadius가 설정되도록 강제 호출
            setNeedsLayout()
        }
    }
}
