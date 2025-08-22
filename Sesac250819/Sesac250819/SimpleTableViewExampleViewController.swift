//
//  SimpleTableViewExampleViewController.swift
//  Sesac250819
//
//  Created by 유태호 on 8/19/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SimpleTableViewExampleViewController: UIViewController {

    let tableView = UITableView()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Simple table view"
        
        configureLayout()
        configure()
        bindTableView()
    }
    
    @objc func dismissViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func bindTableView() {
        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )

        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .disposed(by: disposeBag)

        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext: { value in
                self.presentAlert("Tapped `\(value)`")
            })
            .disposed(by: disposeBag)

        tableView.rx
            .itemAccessoryButtonTapped
            .subscribe(onNext: { indexPath in
                self.presentAlert("Tapped Detail @ \(indexPath.section),\(indexPath.row)")
            })
            .disposed(by: disposeBag)
    }

    func configure() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 44
        tableView.backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func presentAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
