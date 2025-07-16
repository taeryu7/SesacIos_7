//
//  CityTableViewController.swift
//  SeSac250711Report
//
//  Created by 유태호 on 7/16/25.
//

import UIKit
import Kingfisher

struct City {
    let city_name: String
    let city_english_name: String
    let city_explain: String
    let city_image: String
    let domestic_travel: Bool
}

class CityTableViewController: UITableViewController {
    
    @IBOutlet var citySegument: UISegmentedControl!
    
    @IBOutlet var cityTextLabel: UITextField!
    
    
    let cityInfo = CityInfo()
    var filteredCities: [City] = []
    var currentCities: [City] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 타이틀 설정
        self.title = "도시"
        
        // XIB 파일 등록
        tableView.register(UINib(nibName: "CityTableViewCell", bundle: nil),
                          forCellReuseIdentifier: "CityTableViewCell")
        
        // 초기 데이터 설정 (전체 도시)
        currentCities = cityInfo.city
        filteredCities = currentCities
        
        // 세그먼트 컨트롤 설정
        setupSegmentControl()
        
        // 텍스트필드 설정
        setupTextField()
    }
    
    func setupSegmentControl() {
        // 세그먼트 타이틀 설정
        citySegument.setTitle("전체", forSegmentAt: 0)
        citySegument.setTitle("국내", forSegmentAt: 1)
        citySegument.setTitle("해외", forSegmentAt: 2)
        
        // 기본 선택
        citySegument.selectedSegmentIndex = 0
        
        // 액션 추가
        citySegument.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    func setupTextField() {
        cityTextLabel.placeholder = "도시명을 검색해보세요"
        cityTextLabel.borderStyle = .roundedRect
        cityTextLabel.returnKeyType = .search  // 엔터키를 검색 버튼으로 변경
        cityTextLabel.delegate = self  // delegate 설정
        
        // 실시간 검색을 위한 텍스트 변경 감지
        cityTextLabel.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    @objc func segmentChanged() {
        switch citySegument.selectedSegmentIndex {
        case 0: // 전체
            currentCities = cityInfo.city
        case 1: // 국내
            currentCities = cityInfo.city.filter { $0.domestic_travel == true }
        case 2: // 해외
            currentCities = cityInfo.city.filter { $0.domestic_travel == false }
        default:
            currentCities = cityInfo.city
        }
        
        // 검색어가 있다면 다시 필터링
        applySearchFilter()
    }
    
    @objc func textFieldChanged() {
        // 실시간 검색 전에 공백 체크
        guard let text = cityTextLabel.text else {
            applySearchFilter()
            return
        }
        
        // 공백만 입력한 경우 로그 출력
        if !text.isEmpty && text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            print("⚠️ 공백만 입력됨 - 검색어를 입력해주세요")
        }
        
        applySearchFilter()
    }

    
    func applySearchFilter() {
        // 1. 텍스트가 nil이거나 비어있는 경우 처리
        guard let searchText = cityTextLabel.text else {
            filteredCities = currentCities
            tableView.reloadData()
            return
        }
        
        // 2. 공백 제거 (앞뒤 공백, 탭, 줄바꿈 등 모든 whitespace 제거)
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 3. 공백만 입력했거나 빈 문자열인 경우
        if trimmedSearchText.isEmpty {
            // 검색어가 없으므로 현재 카테고리의 모든 도시 표시
            filteredCities = currentCities
            tableView.reloadData()
            print("🔍 검색어가 없음 - 전체 \(currentCities.count)개 도시 표시")
            return
        }
        
        // 4. 유효한 검색어가 있는 경우 - 대소문자 구분없이 검색
        filteredCities = currentCities.filter { city in
            city.city_name.lowercased().contains(trimmedSearchText.lowercased()) ||
            city.city_english_name.lowercased().contains(trimmedSearchText.lowercased()) ||
            city.city_explain.lowercased().contains(trimmedSearchText.lowercased())
        }
        
        tableView.reloadData()
        
        // 5. 검색 결과 피드백
        if filteredCities.isEmpty {
            print("검색 결과가 없습니다: '\(trimmedSearchText)'")
        } else {
            print("'\(trimmedSearchText)' 검색 결과: \(filteredCities.count)개")
        }
    }
    
    // 검색 실행 함수 (엔터키 또는 검색 버튼 클릭 시)
    func performSearch() {
        applySearchFilter()
        cityTextLabel.resignFirstResponder() // 키보드 숨기기
        
        guard let searchText = cityTextLabel.text, !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespaces)
        print("🔍 검색 실행: '\(trimmedSearchText)' - 결과: \(filteredCities.count)개")
    }
    
    
    @IBAction func citySearchAction(_ sender: UITextField) {
        performSearch()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as! CityTableViewCell
        
        let city = filteredCities[indexPath.row]
        
        // 현재 검색어 가져오기
        let currentSearchText = cityTextLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        cell.configure(with: city, searchText: currentSearchText)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedCity = filteredCities[indexPath.row]
        print("선택된 도시: \(selectedCity.city_name)")
        
        // 필요하다면 상세 화면으로 이동하는 코드 추가
        /// to-do 일지도?
    }
}

extension CityTableViewController: UITextFieldDelegate {
    
    // 엔터키(Return/Search) 클릭 시 검색 실행
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == cityTextLabel {
            performSearch()
        }
        return true
    }
    
    // 텍스트필드 편집 시작 시
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("🔍 검색 모드 시작")
    }
    
    // 텍스트필드 편집 종료 시
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("🔍 검색 모드 종료")
    }
    
    // 텍스트 변경 허용 여부 (특수문자 제한 등을 원한다면 사용)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 모든 문자 허용 (한글, 영문, 숫자, 공백 등)
        return true
    }
}
