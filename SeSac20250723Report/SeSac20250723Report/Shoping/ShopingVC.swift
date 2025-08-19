//
//  ShopingVC.swift
//  SeSac20250723Report
//
//  Created by 유태호 on 7/26/25.
//

import UIKit
import SnapKit

class ShopingVC: UIViewController {
    
    private let viewModel = ShoppingViewModel()
    
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
        bindData()
    }
    
    private func bindData() {
        viewModel.output.validationResult.bind {
            let result = self.viewModel.output.validationResult.value
            
            switch result {
            case .failure(let errorMessage):
                self.showAlert(message: errorMessage)
            case .success, .none:
                break
            }
        }
        
        viewModel.output.navigateToSearch.bind {
            if let searchKeyword = self.viewModel.output.navigateToSearch.value {
                let searchResultVC = ShopingSearchVC()
                searchResultVC.searchKeyword = searchKeyword
                self.navigationController?.pushViewController(searchResultVC, animated: true)
            }
        }
    }
}

extension ShopingVC {
    
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
}

extension ShopingVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        viewModel.input.searchText.value = searchBar.text
        viewModel.input.searchButtonTapped.value = ()
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "검색어 입력", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

#Preview {
    ShopingVC()
}
