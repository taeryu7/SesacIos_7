//
//  ShopingSearchVC.swift
//  SeSac20250723Report
//
//  Created by 유태호 on 7/26/25.
//

import UIKit
import SnapKit
import Alamofire

class ShopingSearchVC: UIViewController {
    
    // 검색어 전달받을 프로퍼티
    var searchKeyword: String = ""
    
    // API 키 정보
    private let clientID = ""
    private let clientSecret = ""
    
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
    
    // 데이터
    var shoppingItems: [ShoppingItem] = []
    var totalCount: Int = 0
    
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
        let buttonTitles = ["정확도", "브랜드", "가격대순위", "가격낮은순"]
        
        for title in buttonTitles {
            let button = SortButton()
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
            sortStackView.addArrangedSubview(button)
        }
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
        // 정렬 기능은 추후 구현
        print("정렬 버튼 클릭: \(sender.title(for: .normal) ?? "")")
    }
    
    func requestShoppingAPI() {
        let url = "https://openapi.naver.com/v1/search/shop.json"
        let parameters: Parameters = [
            "query": searchKeyword,
            "display": 100
        ]
        
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": clientID,
            "X-Naver-Client-Secret": clientSecret
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: NaverShoppingResponse.self) { response in
                
                switch response.result {
                case .success(let shoppingResponse):
                    print("API 성공: \(shoppingResponse)")
                    
                    DispatchQueue.main.async {
                        self.shoppingItems = shoppingResponse.items
                        self.totalCount = shoppingResponse.total
                        self.updateUI()
                        self.collectionView.reloadData()
                    }
                    
                case .failure(let error):
                    print("API 실패: \(error)")
                    
                    DispatchQueue.main.async {
                        self.showErrorAlert()
                    }
                }
            }
    }
    
    func updateUI() {
        // 결과 개수 업데이트
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let countString = formatter.string(from: NSNumber(value: totalCount)) ?? "\(totalCount)"
        resultCountLabel.text = "\(countString) 개의 검색 결과"
        
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
}

extension ShopingSearchVC {
    
    func configureHierarchy() {
        view.addSubview(resultCountLabel)
        view.addSubview(sortStackView)
        view.addSubview(collectionView)
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
