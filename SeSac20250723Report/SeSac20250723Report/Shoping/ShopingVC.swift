//
//  ShopingVC.swift
//  SeSac20250723Report
//
//  Created by 유태호 on 7/26/25.
//

import UIKit
import SnapKit

class ShopingVC: UIViewController {
    
    let mainTitleLabel = {
        let mainTitleLabel = ShoppingTitleLabel()
        return mainTitleLabel
    }()
    
    let mainSearchBar = {
        let mainSearchBar = ShoppingSearchBar()
        return mainSearchBar
    }()
    
    let mainImageView = {
        let mainImageView = ShoppingImageView()
        return mainImageView
    }()
    
    let mainSubLabel = {
        let mainSubLabel = ShoppingSubLabel()
        return mainSubLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureUView()
        configureLayout()
    }
}

extension ShopingVC: UISearchBarDelegate {
    
    func configureHierarchy() {
        view.addSubview(mainTitleLabel)
        view.addSubview(mainSearchBar)
        view.addSubview(mainImageView)
        view.addSubview(mainSubLabel)
    }
    
    func configureUView() {
        mainTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(44)
        }
        
        mainSearchBar.snp.makeConstraints { make in
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(44)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(mainSearchBar.snp.bottom).offset(90)
            make.centerX.equalTo(view)
            make.width.height.equalTo(300)
        }
        
        mainSubLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(44)
        }
    }
    
    func configureLayout() {
        view.backgroundColor = .black
        
        mainSearchBar.delegate = self
    }
    
    // 검색 버튼 클릭 시 실행
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // 2글자 이상 입력 검증
        guard let searchText = searchBar.text, searchText.count >= 2 else {
            let alert = UIAlertController(title: "검색어 입력", message: "2글자 이상 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        // 키보드 내리기
        searchBar.resignFirstResponder()
        
        // 검색 결과 화면으로 이동 (검색어 전달)
        let searchResultVC = ShopingSearchVC()
        searchResultVC.searchKeyword = searchText
        navigationController?.pushViewController(searchResultVC, animated: true)
    }
}

#Preview {
    ShopingVC()
}
