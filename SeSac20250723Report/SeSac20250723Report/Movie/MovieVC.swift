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
    let moviesearchBar = UISearchBar()  // 이제 날짜 입력용으로 사용
    let searchButton = UIButton()
    
    var boxOfficeMovies: [DailyBoxOffice] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureUView()
        configureLayout()
        loadBoxOfficeData(for: "20250723") // 초기 데이터 로드
    }
    
    // API 호출해서 박스오피스 데이터 가져오기
    private func loadBoxOfficeData(for date: String) {
        BoxOffice.fetchDailyBoxOffice(for: date) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.boxOfficeMovies = movies
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    // 박스오피스 날짜 포맷 변경 (20250723 -> 2025-07-23)
    private func formatBoxOfficeDate(_ dateString: String) -> String {
        guard dateString.count == 8 else { return dateString }
        
        let year = String(dateString.prefix(4))
        let month = String(dateString.dropFirst(4).prefix(2))
        let day = String(dateString.suffix(2))
        return "\(year)-\(month)-\(day)"
    }
    
    // 알림창 띄우기
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default))
        present(alertController, animated: true)
    }
}

extension MovieVC: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boxOfficeMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieVCTableViewCell.identifier, for: indexPath) as! MovieVCTableViewCell
        
        let movie = boxOfficeMovies[indexPath.row]
        cell.numberLabel.text = movie.rank
        cell.titleLabel.text = movie.movieNm
        cell.dateLabel.text = formatBoxOfficeDate(movie.openDt)
        
        return cell
    }
    
    // 서치바에서 리턴 눌렀을 때
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let dateText = searchBar.text, !dateText.isEmpty else {
            showAlert(message: "날짜를 입력해주세요.\n예: 20221120")
            return
        }
        
        loadBoxOfficeData(for: dateText)
    }
    
    // 뷰 계층 구조 설정
    func configureHierarchy() {
        view.addSubview(moviesearchBar)
        view.addSubview(searchButton)
        view.addSubview(tableView)
    }
    
    // 오토레이아웃 설정
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
    
    // UI 스타일 설정
    func configureLayout() {
        view.backgroundColor = .white
        
        // 서치바 설정
        moviesearchBar.placeholder = "날짜를 입력하세요"
        moviesearchBar.searchBarStyle = .minimal
        moviesearchBar.delegate = self
        moviesearchBar.keyboardType = .numberPad
        
        // 검색 버튼 설정
        searchButton.setTitle("검색", for: .normal)
        searchButton.backgroundColor = .systemBlue
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.layer.cornerRadius = 8
        searchButton.titleLabel?.font = .systemFont(ofSize: 16)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        // 테이블뷰 설정
        tableView.backgroundColor = .orange
        tableView.rowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieVCTableViewCell.self, forCellReuseIdentifier: MovieVCTableViewCell.identifier)
    }
    
    // 검색 버튼 눌렀을 때
    @objc func searchButtonTapped() {
        moviesearchBar.resignFirstResponder()
        
        guard let dateText = moviesearchBar.text, !dateText.isEmpty else {
            showAlert(message: "날짜를 입력해주세요.\n예: 20221120")
            return
        }
        
        loadBoxOfficeData(for: dateText)
    }
}

#Preview {
    MovieVC()
}
