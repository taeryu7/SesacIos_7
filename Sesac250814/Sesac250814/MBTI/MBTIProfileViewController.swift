//
//  MBTIProfileViewController.swift
//  Sesac250814
//
//  Created by 유태호 on 8/16/25.
//

import UIKit
import SnapKit

protocol MBTIProfileDelegate: AnyObject {
    func didSelectProfileImage(index: Int)
}

class MBTIProfileViewController: UIViewController {
    
    weak var delegate: MBTIProfileDelegate?
    private let viewModel: MBTIProfileViewModel
    
    private let previewImageView = UIImageView()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    init(currentImageIndex: Int = 0) {
        self.viewModel = MBTIProfileViewModel(currentImageIndex: currentImageIndex)
        super.init(nibName: nil, bundle: nil)
        setupViewModelDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
        setupCollectionView()
        bindViewModel()
    }
    
    private func setupViewModelDelegate() {
        viewModel.delegate = self
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "PROFILE SETTING"
        
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.layer.cornerRadius = 50
        previewImageView.layer.borderWidth = 3
        previewImageView.layer.borderColor = UIColor.systemBlue.cgColor
        previewImageView.clipsToBounds = true
        previewImageView.backgroundColor = .systemGray5
    }
    
    private func setupLayout() {
        view.addSubview(previewImageView)
        view.addSubview(collectionView)
        
        previewImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(previewImageView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProfileImageCell.self, forCellWithReuseIdentifier: "ProfileImageCell")
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let screenWidth = UIScreen.main.bounds.width
            let totalSpacing = 16 + 16 + (5 * 8)
            let cellWidth = (screenWidth - CGFloat(totalSpacing)) / 6
            layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        }
    }
    
    private func bindViewModel() {
        viewModel.previewImageName.bind { [weak self] in
            DispatchQueue.main.async {
                let imageName = self?.viewModel.previewImageName.value ?? "char1"
                self?.previewImageView.image = UIImage(named: imageName)
            }
        }
        
        viewModel.selectedImageIndex.bind { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    @objc private func backButtonTapped() {
        viewModel.confirmSelection()
        navigationController?.popViewController(animated: true)
    }
}

extension MBTIProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileImageCell", for: indexPath) as! ProfileImageCell
        let profileItem = viewModel.getProfileItem(at: indexPath.item)
        cell.configure(with: profileItem)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectProfileImage(at: indexPath.item)
    }
}

extension MBTIProfileViewController: MBTIProfileViewModelDelegate {
    func didSelectProfileImage(index: Int) {
        delegate?.didSelectProfileImage(index: index)
    }
}

class ProfileImageCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let checkmarkImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        layer.cornerRadius = 8
        clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        
        checkmarkImageView.image = UIImage(systemName: "checkmark.circle.fill")
        checkmarkImageView.tintColor = .systemBlue
        checkmarkImageView.backgroundColor = .white
        checkmarkImageView.layer.cornerRadius = 10
        checkmarkImageView.isHidden = true
    }
    
    private func setupLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(checkmarkImageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        checkmarkImageView.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().offset(-4)
            make.width.height.equalTo(20)
        }
    }
    
    func configure(with profileItem: ProfileImageItem) {
        imageView.image = UIImage(named: profileItem.imageName)
        
        if profileItem.isSelected {
            layer.borderWidth = 2
            layer.borderColor = UIColor.systemBlue.cgColor
            checkmarkImageView.isHidden = false
        } else {
            layer.borderWidth = 0
            checkmarkImageView.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        layer.borderWidth = 0
        checkmarkImageView.isHidden = true
    }
}
