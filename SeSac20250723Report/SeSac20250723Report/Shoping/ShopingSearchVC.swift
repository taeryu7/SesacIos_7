//
//  ShopingSearchVC.swift
//  SeSac20250723Report
//
//  Created by 유태호 on 7/26/25.
//

import UIKit
import SnapKit
import Alamofire

// 정렬 타입 열거형
enum SortType: String, CaseIterable {
    case accuracy = "sim"      // 정확도
    case brand = "brand"       // 브랜드
    case priceDesc = "price"   // 가격대순위 (높은순)
    case priceAsc = "asc"      // 가격낮은순
    
    var displayName: String {
        switch self {
        case .accuracy: return "정확도"
        case .brand: return "브랜드"
        case .priceDesc: return "가격대순위"
        case .priceAsc: return "가격낮은순"
        }
    }
}

class ShopingSearchVC: UIViewController {
    
    // 검색어 전달받을 프로퍼티
    var searchKeyword: String = ""
    
    // API 키 정보
    private let clientID = ""
    private let clientSecret = ""
    
    // 페이지네이션 관련 프로퍼티
    private let itemsPerPage = 30
    private var currentPage = 1
    private var isLoading = false
    private var hasMoreData = true
    private var currentSortType: SortType = .accuracy
    
    // UI 컴포넌트들
    let resultCountLabel = {
        let resultCountLabel = SearchResultCountLabel()
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
    
    // 로딩 인디케이터
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // 데이터
    var shoppingItems: [ShoppingItem] = []
    var totalCount: Int = 0
    
    // 정렬 버튼들을 저장할 배열
    var sortButtons: [SortButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureUView()
        configureLayout()
        setupSortButtons()
        setupCollectionView()
        requestShoppingAPI()
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
    
    @objc func sortButtonTapped(_ sender: UIButton) {
        let selectedSortType = SortType.allCases[sender.tag]
        
        // 같은 정렬이면 무시
        guard selectedSortType != currentSortType else { return }
        
        // 정렬 변경 시 첫 페이지부터 다시 조회
        currentSortType = selectedSortType
        resetPagination()
        updateSortButtonsUI()
        requestShoppingAPI()
        
        print("정렬 변경: \(selectedSortType.displayName)")
    }
    
    func updateSortButtonsUI() {
        for (index, button) in sortButtons.enumerated() {
            let sortType = SortType.allCases[index]
            let isSelected = sortType == currentSortType
            
            button.backgroundColor = isSelected ? .systemTeal : .systemGray6
            button.setTitleColor(isSelected ? .white : .black, for: .normal)
            button.layer.borderColor = isSelected ? UIColor.systemTeal.cgColor : UIColor.systemGray5.cgColor
        }
    }
    
    func resetPagination() {
        currentPage = 1
        shoppingItems.removeAll()
        hasMoreData = true
        collectionView.reloadData()
    }
    
    func requestShoppingAPI() {
        // 이미 로딩 중이거나 더 이상 데이터가 없으면 중단
        guard !isLoading && hasMoreData else { return }
        
        isLoading = true
        
        // 로딩 인디케이터 표시
        if currentPage == 1 {
            loadingIndicator.startAnimating()
        }
        
        let url = "https://openapi.naver.com/v1/search/shop.json"
        let startIndex = (currentPage - 1) * itemsPerPage + 1
        
        let parameters: Parameters = [
            "query": searchKeyword,
            "display": itemsPerPage,
            "start": startIndex,
            "sort": currentSortType.rawValue
        ]
        
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": clientID,
            "X-Naver-Client-Secret": clientSecret
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: NaverShoppingResponse.self) { response in
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.loadingIndicator.stopAnimating()
                }
                
                switch response.result {
                case .success(let shoppingResponse):
                    print("API 성공: 페이지 \(self.currentPage), 아이템 수: \(shoppingResponse.items.count)")
                    
                    DispatchQueue.main.async {
                        if self.currentPage == 1 {
                            // 첫 페이지면 기존 데이터 교체
                            self.shoppingItems = shoppingResponse.items
                            self.totalCount = shoppingResponse.total
                        } else {
                            // 추가 페이지면 기존 데이터에 추가
                            self.shoppingItems.append(contentsOf: shoppingResponse.items)
                        }
                        
                        // 더 이상 데이터가 없는지 확인
                        self.hasMoreData = shoppingResponse.items.count == self.itemsPerPage
                        
                        self.updateUI()
                        self.collectionView.reloadData()
                        self.currentPage += 1
                    }
                    
                case .failure(let error):
                    print("API 실패: \(error)")
                    
                    DispatchQueue.main.async {
                        self.showErrorAlert()
                    }
                }
            }
    }
    
    func loadNextPageIfNeeded() {
        requestShoppingAPI()
    }
    
    func updateUI() {
        // 결과 개수 업데이트 (첫 페이지에서만)
        if currentPage <= 2 {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let countString = formatter.string(from: NSNumber(value: totalCount)) ?? "\(totalCount)"
            resultCountLabel.text = "\(countString) 개의 검색 결과"
        }
        
        // 네비게이션 타이틀 설정
        navigationItem.title = searchKeyword
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "오류", message: "검색 결과를 불러오는데 실패했습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

extension ShopingSearchVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shoppingItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopingSearchCollectionViewCell.identifier, for: indexPath) as! ShopingSearchCollectionViewCell
        
        let item = shoppingItems[indexPath.item]
        cell.configure(with: item)
        
        return cell
    }
    
    // 스크롤 감지로 페이지네이션 처리
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // 마지막에서 5개 전 아이템에 도달했을 때 다음 페이지 로드
        if indexPath.item >= shoppingItems.count - 5 {
            loadNextPageIfNeeded()
        }
    }
}

extension ShopingSearchVC {
    
    func configureHierarchy() {
        view.addSubview(resultCountLabel)
        view.addSubview(sortStackView)
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
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
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sortStackView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalTo(view)
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

#Preview {
    ShopingSearchVC()
}
