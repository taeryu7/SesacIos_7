//
//  SearchViewController.swift
//  Sesac250814
//
//  Created by 유태호 on 8/14/25.
//

import UIKit
import SnapKit

final class SearchViewController: UIViewController {
    
    private let viewModel = SearchViewModel()
    
    private let searchBar = UISearchBar()
    private let sortButton = UIButton()
    
    // 색상 필터 컬렉션뷰
    private let colorFilterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: 60, height: 20)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // 사진 컬렉션뷰
    private let photoCollectionView: UICollectionView = {
        let layout = PinterestLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // 상태 표시 라벨들
    private let emptyLabel = UILabel()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
        setupCollectionViews()
        bindViewModel()
        showEmptyState()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // 네비게이션 타이틀로 설정
        title = "검색"
        
        // 검색바
        searchBar.placeholder = "키워드 검색"
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        
        // 정렬 버튼 (하나의 토글 버튼으로 변경)
        setupSortButton()
        
        // 빈 상태 라벨
        emptyLabel.text = "사진을 검색해보세요"
        emptyLabel.textColor = .systemGray
        emptyLabel.textAlignment = .center
        emptyLabel.font = .systemFont(ofSize: 16)
        
        // 로딩 인디케이터
        loadingIndicator.hidesWhenStopped = true
    }
    
    private func setupSortButton() {
        sortButton.setTitle("관련순", for: .normal)
        sortButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        sortButton.setTitleColor(.black, for: .normal)
        sortButton.backgroundColor = .white
        sortButton.layer.cornerRadius = 8
        sortButton.layer.borderWidth = 1
        sortButton.layer.borderColor = UIColor.systemGray4.cgColor
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(searchBar)
        view.addSubview(colorFilterCollectionView)
        view.addSubview(sortButton)
        view.addSubview(photoCollectionView)
        view.addSubview(emptyLabel)
        view.addSubview(loadingIndicator)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        colorFilterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(15)
            make.leading.equalToSuperview()
            make.trailing.equalTo(sortButton.snp.leading).offset(-10)
            make.height.equalTo(20)
        }
        
        sortButton.snp.makeConstraints { make in
            make.centerY.equalTo(colorFilterCollectionView)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(80)
            make.height.equalTo(18)
        }
        
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(colorFilterCollectionView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalTo(photoCollectionView)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalTo(photoCollectionView)
        }
    }
    
    private func setupCollectionViews() {
        // 색상 필터 컬렉션뷰
        colorFilterCollectionView.delegate = self
        colorFilterCollectionView.dataSource = self
        colorFilterCollectionView.register(ColorFilterCell.self, forCellWithReuseIdentifier: "ColorFilterCell")
        
        // 사진 컬렉션뷰
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        
        if let layout = photoCollectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }
    
    @objc private func sortButtonTapped() {
        let currentSort = viewModel.input.sortOrder.value
        let nextSort: SortOrder
        
        switch currentSort {
        case .relevant:
            nextSort = .latest
        case .latest:
            nextSort = .likes
        case .likes:
            nextSort = .relevant
        }
        
        viewModel.input.sortOrder.value = nextSort
        sortButton.setTitle(nextSort.displayName, for: .normal)
        
        // 검색어가 있으면 다시 검색
        if !viewModel.input.searchText.value.isEmpty {
            viewModel.input.searchTrigger.value = ()
        }
    }
    
    private func bindViewModel() {
        viewModel.output.isLoading.bind(owner: self) { [weak self] in
            DispatchQueue.main.async {
                if self?.viewModel.output.isLoading.value == true {
                    self?.showLoading()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.output.photos.bind(owner: self) { [weak self] in
            DispatchQueue.main.async {
                self?.photoCollectionView.reloadData()
                self?.photoCollectionView.isHidden = self?.viewModel.output.photos.value.isEmpty ?? true
            }
        }
        
        viewModel.output.isEmpty.bind(owner: self) { [weak self] in
            DispatchQueue.main.async {
                if self?.viewModel.output.isEmpty.value == true {
                    self?.showNoResults()
                }
            }
        }
        
        viewModel.output.error.bind(owner: self) { [weak self] in
            DispatchQueue.main.async {
                if let error = self?.viewModel.output.error.value {
                    self?.showAlert(message: error)
                }
            }
        }
        
        viewModel.input.selectedColorFilter.bind(owner: self) { [weak self] in
            DispatchQueue.main.async {
                self?.colorFilterCollectionView.reloadData()
            }
        }
    }

    private func showEmptyState() {
        emptyLabel.text = "사진을 검색해보세요"
        emptyLabel.isHidden = false
        photoCollectionView.isHidden = true
    }
    
    private func showNoResults() {
        emptyLabel.text = "검색 결과가 없습니다"
        emptyLabel.isHidden = false
        photoCollectionView.isHidden = true
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

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        viewModel.input.searchText.value = text.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.input.searchTrigger.value = ()
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colorFilterCollectionView {
            return ColorFilter.allCases.count
        } else {
            return viewModel.output.photos.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == colorFilterCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorFilterCell", for: indexPath) as! ColorFilterCell
            let colorFilter = ColorFilter.allCases[indexPath.item]
            let isSelected = (viewModel.input.selectedColorFilter.value == colorFilter)
            cell.configure(with: colorFilter, isSelected: isSelected)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
            let photo = viewModel.output.photos.value[indexPath.item]
            cell.configure(with: photo)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == colorFilterCollectionView {
            let tappedFilter = ColorFilter.allCases[indexPath.item]
            
            // 이미 선택된 색감을 다시 누르면 선택 해제
            if viewModel.input.selectedColorFilter.value == tappedFilter {
                viewModel.input.selectedColorFilter.value = nil
            } else {
                viewModel.input.selectedColorFilter.value = tappedFilter
            }
            
            // 검색어가 있으면 필터 적용하여 다시 검색
            if !viewModel.input.searchText.value.isEmpty {
                viewModel.input.searchTrigger.value = ()
            }
            
            print("색상 선택됨: \(tappedFilter.displayName)")
        } else {
            let photo = viewModel.output.photos.value[indexPath.item]
            let detailVC = PhotoDetailViewController(photo: photo)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension SearchViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let photos = viewModel.output.photos.value
        guard indexPath.item < photos.count else { return 200 }
        
        let photo = photos[indexPath.item]
        let aspectRatio = CGFloat(photo.height) / CGFloat(photo.width)
        let cellWidth = (collectionView.frame.width - 30) / 2
        return cellWidth * aspectRatio
    }
}
