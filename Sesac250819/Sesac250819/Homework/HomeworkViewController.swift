//
//  HomeworkViewController.swift
//  RxSwift
//
//  Created by Jack on 1/30/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class HomeworkViewController: UIViewController {
    
    let tableView = UITableView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let searchBar = UISearchBar()
    
    private let viewModel = HomeworkViewModel()
    private let disposeBag = DisposeBag()
    
    // 더보기 버튼 탭 이벤트를 관리하기 위한 Subject
    private let detailButtonTapSubject = PublishSubject<Person>()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bindViewModel()
    }
     
    private func bindViewModel() {
        let input = HomeworkViewModel.Input(
            itemSelected: tableView.rx.itemSelected,
            searchText: searchBar.rx.searchButtonClicked.withLatestFrom(searchBar.rx.text.orEmpty).asObservable(),
            detailButtonTap: detailButtonTapSubject.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        // 사용자 목록 바인딩
        output.allUsers
            .drive(tableView.rx.items(cellIdentifier: PersonTableViewCell.identifier, cellType: PersonTableViewCell.self)) { [weak self] index, person, cell in
                self?.configureTableCell(cell: cell, person: person, index: index)
            }
            .disposed(by: disposeBag)
        
        // 선택된 사용자 목록 바인딩
        output.selectedUsers
            .drive(collectionView.rx.items(cellIdentifier: UserCollectionViewCell.identifier, cellType: UserCollectionViewCell.self)) { index, name, cell in
                cell.label.text = name
            }
            .disposed(by: disposeBag)
        
        // 테이블뷰 선택 시 선택 해제
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        // 검색 후 검색바 클리어 및 키보드 숨기기
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                self?.searchBar.text = ""
                self?.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        // 상세 화면 이동
        output.showUserDetail
            .drive(onNext: { [weak self] person in
                self?.showUserDetail(person: person)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureTableCell(cell: PersonTableViewCell, person: Person, index: Int) {
        cell.usernameLabel.text = person.name
        
        // 이미지 로드
        if let url = URL(string: person.profileImage) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.profileImageView.image = image
                    }
                }
            }.resume()
        }
        
        // 더보기 버튼 탭 이벤트 바인딩
        cell.detailButton.rx.tap
            .map { person }
            .bind(to: detailButtonTapSubject)
            .disposed(by: disposeBag)
    }
    
    private func showUserDetail(person: Person) {
        let detailViewController = UserDetailViewController(person: person)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
        searchBar.placeholder = "사용자 추가"
         
        collectionView.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: UserCollectionViewCell.identifier)
        collectionView.backgroundColor = .lightGray
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: PersonTableViewCell.identifier)
        tableView.backgroundColor = .systemGreen
        tableView.rowHeight = 100
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
}
