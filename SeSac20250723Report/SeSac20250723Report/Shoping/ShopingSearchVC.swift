//
//  ShopingSearchVC.swift
//  SeSac20250723Report
//
//  Created by 유태호 on 7/26/25.
//

import UIKit
import SnapKit

// 정렬 타입 열거형
enum SortType: String, CaseIterable {
    case accuracy = "sim"      // 정확도 (유사도순)
    case date = "date"         // 날짜순
    case priceDesc = "dsc"     // 가격높은순
    case priceAsc = "asc"      // 가격낮은순
    
    var displayName: String {
        switch self {
        case .accuracy: return "정확도"
        case .date: return "날짜순"
        case .priceDesc: return "가격높은순"
        case .priceAsc: return "가격낮은순"
        }
    }
}

class ShopingSearchVC: UIViewController {
    
    // ViewModel
    private let viewModel = ShopingSearchViewModel()
    
    // 검색어 전달받을 프로퍼티
    var searchKeyword: String = ""
    
    // UI 컴포넌트들
    let resultCountLabel = {
        let resultCountLabel = SearchResultCountLabel()
        
        //SortType(rawValue: "date")
        
        return resultCountLabel
    }()
    
    let sortStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // 하단 추천 상품 관련 UI
    let recommendationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "추천상품"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    let bottomCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // 로딩 인디케이터들
    let mainLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    let paginationLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .systemTeal
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // 로딩 배경뷰
    let loadingBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.isHidden = true
        return view
    }()
    
    // 정렬 버튼들을 저장할 배열
    var sortButtons: [SortButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureUView()
        configureLayout()
        setupSortButtons()
        setupCollectionView()
        setupBottomCollectionView()
        bindData()
        
        // 검색 시작
        viewModel.input.initialSearch.value = searchKeyword
        navigationItem.title = searchKeyword
    }
    
    private func bindData() {
        viewModel.output.shoppingItems.bind {
            self.collectionView.reloadData()
        }
        
        viewModel.output.randomItems.bind {
            self.bottomCollectionView.reloadData()
        }
        
        viewModel.output.isMainLoading.bind {
            if self.viewModel.output.isMainLoading.value {
                self.showMainLoading()
            } else {
                self.hideMainLoading()
            }
        }
        
        viewModel.output.isPaginationLoading.bind {
            if self.viewModel.output.isPaginationLoading.value {
                self.showPaginationLoading()
            } else {
                self.hidePaginationLoading()
            }
        }
        
        viewModel.output.error.bind {
            if let error = self.viewModel.output.error.value {
                let message = error.message
                self.showErrorAlert(title: message.title, message: message.description)
            }
        }
        
        viewModel.output.totalCountText.bind {
            self.resultCountLabel.text = self.viewModel.output.totalCountText.value
        }
    }
    
    func setupSortButtons() {
        let sortTypes = SortType.allCases
        
        for (index, sortType) in sortTypes.enumerated() {
            let button = SortButton()
            button.setTitle(sortType.displayName, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
            sortStackView.addArrangedSubview(button)
            sortButtons.append(button)
        }
        
        // 초기 선택 상태 설정 (정확도)
        updateSortButtonsUI()
    }
    
    func setupCollectionView() {
        // 플로우 레이아웃 설정
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        // 셀 크기 계산
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - 50) / 2  // 좌우 여백 20 + 중간 간격 10
        layout.itemSize = CGSize(width: cellWidth, height: 240)
        
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        collectionView.collectionViewLayout = layout
    }
    
    func setupBottomCollectionView() {
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        bottomCollectionView.register(RecommendationCollectionViewCell.self, forCellWithReuseIdentifier: RecommendationCollectionViewCell.identifier)
    }
    
    @objc func sortButtonTapped(_ sender: UIButton) {
        let selectedSortType = SortType.allCases[sender.tag]
        
        viewModel.input.sortChanged.value = selectedSortType
        updateSortButtonsUI()
        
        print("정렬 변경: \(selectedSortType.displayName)")
    }
    
    func updateSortButtonsUI() {
        let currentSortType = viewModel.getCurrentSortType()
        
        for (index, button) in sortButtons.enumerated() {
            let sortType = SortType.allCases[index]
            let isSelected = sortType == currentSortType
            
            button.backgroundColor = isSelected ? .systemTeal : .systemGray6
            button.setTitleColor(isSelected ? .white : .black, for: .normal)
            button.layer.borderColor = isSelected ? UIColor.systemTeal.cgColor : UIColor.systemGray5.cgColor
        }
    }
    
    func showMainLoading() {
        loadingBackgroundView.isHidden = false
        mainLoadingIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    func hideMainLoading() {
        loadingBackgroundView.isHidden = true
        mainLoadingIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    func showPaginationLoading() {
        paginationLoadingIndicator.startAnimating()
    }
    
    func hidePaginationLoading() {
        paginationLoadingIndicator.stopAnimating()
    }
    
    func showErrorAlert(title: String = "오류", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// 메인 컬렉션뷰
extension ShopingSearchVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return viewModel.output.shoppingItems.value.count
        } else if collectionView == bottomCollectionView {
            return viewModel.output.randomItems.value.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopingSearchCollectionViewCell.identifier, for: indexPath) as! ShopingSearchCollectionViewCell
            
            let item = viewModel.output.shoppingItems.value[indexPath.item]
            cell.configure(with: item)
            
            return cell
        } else if collectionView == bottomCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendationCollectionViewCell.identifier, for: indexPath) as! RecommendationCollectionViewCell
            
            let item = viewModel.output.randomItems.value[indexPath.item]
            cell.configure(with: item)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    // 스크롤 감지로 페이지네이션 처리 (메인 컬렉션뷰만)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            // 마지막에서 5개 전 아이템에 도달했을 때 다음 페이지 로드
            if viewModel.shouldLoadNextPage(currentIndex: indexPath.item) {
                viewModel.input.loadNextPage.value = ()
            }
        }
    }
}


extension ShopingSearchVC {
    
    func configureHierarchy() {
        view.addSubview(resultCountLabel)
        view.addSubview(sortStackView)
        view.addSubview(collectionView)
        
        // 하단 추천상품 관련 뷰 추가
        view.addSubview(recommendationTitleLabel)
        view.addSubview(bottomCollectionView)
        
        // 로딩 관련 뷰들 추가
        view.addSubview(loadingBackgroundView)
        loadingBackgroundView.addSubview(mainLoadingIndicator)
        view.addSubview(paginationLoadingIndicator)
    }
    
    func configureUView() {
        resultCountLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(20)
        }
        
        sortStackView.snp.makeConstraints { make in
            make.top.equalTo(resultCountLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(35)
        }
        
        // 추천상품 타이틀 라벨
        recommendationTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(bottomCollectionView.snp.top).offset(-5)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(20)
        }
        
        // 하단 가로 컬렉션뷰
        bottomCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.height.equalTo(110)
        }
        
        // 메인 컬렉션뷰 (하단 컬렉션뷰 위까지)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sortStackView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(recommendationTitleLabel.snp.top).offset(-10)
        }
        
        // 로딩 관련 제약조건
        loadingBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        mainLoadingIndicator.snp.makeConstraints { make in
            make.center.equalTo(loadingBackgroundView)
        }
        
        paginationLoadingIndicator.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(recommendationTitleLabel.snp.top).offset(-20)
        }
    }
    
    func configureLayout() {
        view.backgroundColor = .black
        
        // 컬렉션뷰 설정
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ShopingSearchCollectionViewCell.self, forCellWithReuseIdentifier: ShopingSearchCollectionViewCell.identifier)
        
        // 네비게이션 설정
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
}


class RecommendationCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RecommendationCollectionViewCell"
    
    let productImageView = UIImageView()
    let priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(productImageView)
        contentView.addSubview(priceLabel)
        
        backgroundColor = .systemGray6
        layer.cornerRadius = 8
        clipsToBounds = true
        
        productImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(70)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(4)
            make.leading.trailing.equalTo(contentView).inset(4)
            make.bottom.equalTo(contentView).offset(-4)
        }
        
        // 이미지뷰 설정
        productImageView.backgroundColor = .systemGray5
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        
        // 가격 라벨 설정
        priceLabel.font = .systemFont(ofSize: 11, weight: .medium)
        priceLabel.textColor = .black
        priceLabel.textAlignment = .center
        priceLabel.numberOfLines = 1
    }
    
    func configure(with item: ShoppingItem) {
        // 가격 포맷팅
        if let price = Int(item.lprice) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            priceLabel.text = "\(formatter.string(from: NSNumber(value: price)) ?? "")원"
        } else {
            priceLabel.text = "\(item.lprice)원"
        }
        
        // 이미지 로드
        loadImage(from: item.image)
    }
    
    private func loadImage(from urlString: String) {
        productImageView.image = nil
        
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.productImageView.image = image
                }
            }
        }
    }
}

#Preview {
    ShopingSearchVC()
}
