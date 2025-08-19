//
//  LikeViewController.swift
//  Sesac250814
//
//  Created by 유태호 on 8/15/25.
//

import UIKit
import SnapKit

final class LikeViewController: UIViewController {
    
    private let viewModel = LikeViewModel()
    
    private let photoCollectionView: UICollectionView = {
        let layout = PinterestLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let emptyLabel = UILabel()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
        setupCollectionView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshLikedPhotos()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "좋아요"
        
        emptyLabel.text = "좋아요한 사진이 없습니다"
        emptyLabel.textColor = .systemGray
        emptyLabel.textAlignment = .center
        emptyLabel.font = .systemFont(ofSize: 16)
        
        loadingIndicator.hidesWhenStopped = true
    }
    
    private func setupLayout() {
        view.addSubview(photoCollectionView)
        view.addSubview(emptyLabel)
        view.addSubview(loadingIndicator)
        
        photoCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalTo(photoCollectionView)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalTo(photoCollectionView)
        }
    }
    
    private func setupCollectionView() {
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        
        if let layout = photoCollectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }
    
    private func bindViewModel() {
        viewModel.likedPhotos.bind(owner: self) { [weak self] in
            DispatchQueue.main.async {
                self?.photoCollectionView.reloadData()
            }
        }
        
        viewModel.isLoading.bind(owner: self) { [weak self] in
            DispatchQueue.main.async {
                if self?.viewModel.isLoading.value == true {
                    self?.showLoading()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.isEmpty.bind(owner: self) { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        
        viewModel.error.bind(owner: self) { [weak self] in
            DispatchQueue.main.async {
                if let error = self?.viewModel.error.value {
                    self?.showAlert(message: error)
                }
            }
        }
    }
    
    private func updateUI() {
        let isEmpty = viewModel.isEmpty.value
        emptyLabel.isHidden = !isEmpty
        photoCollectionView.isHidden = isEmpty
    }
    
    private func showLoading() {
        emptyLabel.isHidden = true
        photoCollectionView.isHidden = true
        loadingIndicator.startAnimating()
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

extension LikeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getPhotoCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        if let photo = viewModel.getPhoto(at: indexPath.item) {
            cell.configure(with: photo)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let photo = viewModel.getPhoto(at: indexPath.item) {
            let detailVC = PhotoDetailViewController(photo: photo)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension LikeViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let photo = viewModel.getPhoto(at: indexPath.item) else { return 200 }
        
        let aspectRatio = CGFloat(photo.height) / CGFloat(photo.width)
        let cellWidth = (collectionView.frame.width - 30) / 2
        return cellWidth * aspectRatio
    }
}
