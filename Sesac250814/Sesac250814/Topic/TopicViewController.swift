//
//  TopicViewController.swift
//  Sesac250814
//
//  Created by 유태호 on 8/14/25.
//

import UIKit
import SnapKit

final class TopicViewController: UIViewController {
    
    private let viewModel = TopicViewModel()
    
    // UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let ourTopicLabel = UILabel()
    
    private let goldenHourLabel = UILabel()
    private let businessLabel = UILabel()
    private let architectureLabel = UILabel()
    
    private lazy var goldenHourCollectionView = createHorizontalCollectionView(tag: 0)
    private lazy var businessCollectionView = createHorizontalCollectionView(tag: 1)
    private lazy var architectureCollectionView = createHorizontalCollectionView(tag: 2)
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    private var profileImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
        bindViewModel()
        viewModel.loadAllTopicPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshProfileImage()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "토픽"
        
        setupNavigationButton()
        
        ourTopicLabel.text = "OUR TOPIC"
        ourTopicLabel.font = .systemFont(ofSize: 22, weight: .bold)
        ourTopicLabel.textColor = .black
        
        // 라벨들은 뷰모델에서 가져온 토픽 제목으로 설정
        let topics = Topic.allTopics
        [goldenHourLabel, businessLabel, architectureLabel].enumerated().forEach { index, label in
            label.text = topics[index].title
            label.font = .systemFont(ofSize: 18, weight: .bold)
            label.textColor = .black
        }
        
        loadingIndicator.hidesWhenStopped = true
    }
    
    private func setupNavigationButton() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.systemBlue.cgColor
        imageView.backgroundColor = .clear
        imageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileButtonTapped))
        imageView.addGestureRecognizer(tapGesture)
        
        containerView.addSubview(imageView)
        profileImageView = imageView
        
        let barButtonItem = UIBarButtonItem(customView: containerView)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func bindViewModel() {
        viewModel.topicSections.bind(owner: self) { [weak self] in
            DispatchQueue.main.async {
                self?.reloadAllCollectionViews()
            }
        }
        
        viewModel.isLoading.bind(owner: self) { [weak self] in
            DispatchQueue.main.async {
                if self?.viewModel.isLoading.value == true {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.error.bind(owner: self) { [weak self] in
            DispatchQueue.main.async {
                if let error = self?.viewModel.error.value {
                    self?.showAlert(message: error)
                }
            }
        }
        
        viewModel.profileImageIndex.bind(owner: self) { [weak self] in
            DispatchQueue.main.async {
                self?.updateProfileButton()
            }
        }
    }

    private func updateProfileButton() {
        guard let imageView = profileImageView else { return }
        
        if let imageIndex = viewModel.profileImageIndex.value {
            let imageName = "char\(imageIndex + 1)"
            if let profileImage = UIImage(named: imageName) {
                imageView.image = profileImage
            } else {
                imageView.image = UIImage(systemName: "person.circle.fill")
            }
        } else {
            imageView.image = UIImage(systemName: "person.circle.fill")
        }
    }
    
    @objc private func profileButtonTapped() {
        let mbtiVC = MBTIViewController()
        navigationController?.pushViewController(mbtiVC, animated: true)
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(loadingIndicator)
        
        [ourTopicLabel,
         goldenHourLabel, goldenHourCollectionView,
         businessLabel, businessCollectionView,
         architectureLabel, architectureCollectionView].forEach {
            contentView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        ourTopicLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        goldenHourLabel.snp.makeConstraints { make in
            make.top.equalTo(ourTopicLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        goldenHourCollectionView.snp.makeConstraints { make in
            make.top.equalTo(goldenHourLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        businessLabel.snp.makeConstraints { make in
            make.top.equalTo(goldenHourCollectionView.snp.bottom).offset(24)
            make.leading.trailing.equalTo(goldenHourLabel)
        }
        
        businessCollectionView.snp.makeConstraints { make in
            make.top.equalTo(businessLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        architectureLabel.snp.makeConstraints { make in
            make.top.equalTo(businessCollectionView.snp.bottom).offset(24)
            make.leading.trailing.equalTo(goldenHourLabel)
        }
        
        architectureCollectionView.snp.makeConstraints { make in
            make.top.equalTo(architectureLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func createHorizontalCollectionView(tag: Int) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 200)
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TopicPhotoCell.self, forCellWithReuseIdentifier: "TopicPhotoCell")
        collectionView.tag = tag
        
        return collectionView
    }
    
    private func reloadAllCollectionViews() {
        goldenHourCollectionView.reloadData()
        businessCollectionView.reloadData()
        architectureCollectionView.reloadData()
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

extension TopicViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let topicSection = viewModel.getTopicSection(at: collectionView.tag) else { return 0 }
        return topicSection.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopicPhotoCell", for: indexPath) as! TopicPhotoCell
        
        if let photo = viewModel.getPhoto(topicIndex: collectionView.tag, photoIndex: indexPath.item) {
            cell.configure(with: photo)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let photo = viewModel.getPhoto(topicIndex: collectionView.tag, photoIndex: indexPath.item) {
            let detailVC = PhotoDetailViewController(photo: photo)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
