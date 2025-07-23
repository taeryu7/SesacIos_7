//
//  MovieVC.swift
//  SeSac20250723Report
//
//  Created by 유태호 on 7/24/25.
//

import UIKit
import SnapKit

class MovieVC: UIViewController {
    
    let tableView = UITableView()
    let moviesearchBar = UISearchBar()
    let searchButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureUView()
        configureLayout()
    }
}

extension MovieVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieVCTableViewCell.identifier, for: indexPath) as! MovieVCTableViewCell
        return cell
    }
    
    func configureHierarchy() {
        view.addSubview(moviesearchBar)
        view.addSubview(searchButton)
        view.addSubview(tableView)
    }
    
    func configureUView() {
        moviesearchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(searchButton.snp.leading).offset(-10)
            make.height.equalTo(44)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(44)
            make.width.equalTo(80)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(moviesearchBar.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureLayout() {
        view.backgroundColor = .white
        
        // 서치바 설정
        moviesearchBar.placeholder = "영화를 검색해보세요"
        moviesearchBar.searchBarStyle = .minimal
        
        // 검색 버튼 설정
        searchButton.setTitle("검색", for: .normal)
        searchButton.backgroundColor = .systemBlue
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.layer.cornerRadius = 8
        searchButton.titleLabel?.font = .systemFont(ofSize: 16)
        
        // 테이블뷰 설정
        tableView.backgroundColor = .orange
        tableView.rowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieVCTableViewCell.self, forCellReuseIdentifier: MovieVCTableViewCell.identifier)
    }
}

#Preview {
    MovieVC()
}
