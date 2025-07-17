//
//  CityViewController.swift
//  SeSac250711Report
//
//  Created by 유태호 on 7/17/25.
//

import UIKit

class CityViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var citySegment: UISegmentedControl!
    
    @IBOutlet var cityCollection: UICollectionView!
    
    let cityInfo = CityInfo()
    var currentCities: [City] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 타이틀 설정
        self.title = "도시"
        
        // XIB 파일 등록
        let xib = UINib(nibName: "CityCollectionViewCell", bundle: nil)
        cityCollection.register(xib, forCellWithReuseIdentifier: "CityCollectionViewCell")
        
        // 델리게이트 설정
        cityCollection.delegate = self
        cityCollection.dataSource = self
        
        // 초기 데이터 설정 (전체 도시)
        currentCities = cityInfo.city
        
        // 세그먼트 컨트롤 설정
        setupSegmentControl()
        
        // 컬렉션뷰 레이아웃 설정
        setupCollectionViewLayout()
    }
    
    func setupSegmentControl() {
        // 세그먼트 타이틀 설정
        citySegment.setTitle("전체", forSegmentAt: 0)
        citySegment.setTitle("국내", forSegmentAt: 1)
        citySegment.setTitle("해외", forSegmentAt: 2)
        
        // 기본 선택
        citySegment.selectedSegmentIndex = 0
        
        // 액션 추가
        citySegment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        
        // 화면 넓이 계산
        let deviceWidth = UIScreen.main.bounds.width
        
        let totalHorizontalPadding: CGFloat = 16 * 2 + 14 // 좌우 여백 + 셀 간격
        let cellWidth: CGFloat = (deviceWidth - totalHorizontalPadding) / 2
        
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth + 140)
        
        // 전체 섹션 여백
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        // 셀 간 간격
        layout.minimumInteritemSpacing = 14
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        
        cityCollection.collectionViewLayout = layout
    }
    
    @objc func segmentChanged() {
        switch citySegment.selectedSegmentIndex {
        case 0: // 전체
            currentCities = cityInfo.city
        case 1: // 국내
            currentCities = cityInfo.city.filter { $0.domestic_travel == true }
        case 2: // 해외
            currentCities = cityInfo.city.filter { $0.domestic_travel == false }
        default:
            currentCities = cityInfo.city
        }
        
        // 컬렉션뷰 리로드
        cityCollection.reloadData()
        
        // 스크롤을 맨 위로 이동
        if !currentCities.isEmpty {
            cityCollection.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
}

// UICollectionViewDataSource & Delegate
extension CityViewController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityCollectionViewCell", for: indexPath) as! CityCollectionViewCell
        
        let city = currentCities[indexPath.item]
        cell.configure(with: city)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCity = currentCities[indexPath.item]
        print("선택된 도시: \(selectedCity.city_name)")
    }
}
