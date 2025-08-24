//
//  TamaSubViewController.swift
//  20250708SeSacReport
//
//  Created by 유태호 on 7/9/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TamaSubViewController: UIViewController {
    
    let tableView = UITableView()
    
    private let viewModel = TamaSubViewModel()
    private let disposeBag = DisposeBag()
    
    private var settingItems: [TamaSubModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        setupNavigationBar()
        setupTableView()
        bindViewModel()
        
        viewModel.viewDidLoadTrigger.onNext(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppearTrigger.onNext(())
    }
    
    private func bindViewModel() {
        viewModel.settingItems
            .drive(onNext: { [weak self] items in
                self?.settingItems = items
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.menuSelection)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.showNameChangeScreen
            .drive(onNext: { [weak self] in
                self?.showNameChangeScreen()
            })
            .disposed(by: disposeBag)
        
        viewModel.showTamagochiChangeScreen
            .drive(onNext: { [weak self] in
                self?.showTamagochiChangeScreen()
            })
            .disposed(by: disposeBag)
        
        viewModel.showDataResetAlert
            .drive(onNext: { [weak self] in
                self?.showDataResetScreen()
            })
            .disposed(by: disposeBag)
    }
    
    private func showNameChangeScreen() {
        let nameChangeVC = TamaNameChangeViewController()
        navigationController?.pushViewController(nameChangeVC, animated: true)
    }
    
    private func showTamagochiChangeScreen() {
        let currentLevel = TamagochiUserDefaults.shared.loadTamagochiLevel()
        let currentRiceCount = TamagochiUserDefaults.shared.loadRiceCount()
        let currentWaterCount = TamagochiUserDefaults.shared.loadWaterCount()
        let currentName = TamagochiUserDefaults.shared.loadTamagochiName()
        
        let selectVC = TamaSelectViewController()
        
        selectVC.isChangingTamagochi = true
        selectVC.onTamagochiChanged = { [weak self] in
            TamagochiUserDefaults.shared.saveTamagochiData(
                level: currentLevel,
                riceCount: currentRiceCount,
                waterCount: currentWaterCount
            )
            TamagochiUserDefaults.shared.saveTamagochiName(currentName)
            
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        navigationController?.pushViewController(selectVC, animated: true)
    }
    
    private func showDataResetScreen() {
        let alert = UIAlertController(
            title: "데이터 초기화",
            message: "정말 다시 처음부터 시작하실 건가요?",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "아니", style: .cancel)
        let resetAction = UIAlertAction(title: "응", style: .destructive) { _ in
            TamagochiUserDefaults.shared.resetAllData()
            
            let selectVC = TamaSelectViewController()
            let navController = UINavigationController(rootViewController: selectVC)
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = navController
                sceneDelegate.window?.makeKeyAndVisible()
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(resetAction)
        
        present(alert, animated: true)
    }
}

extension TamaSubViewController {
    
    func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    func configureLayout() {
        view.backgroundColor = .systemBackground
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "설정"
        
        navigationController?.navigationBar.tintColor = UIColor.label
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "SettingCell")
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .systemBackground
    }
}

extension TamaSubViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingTableViewCell
        
        let item = settingItems[indexPath.row]
        cell.configure(title: item.title, subtitle: item.subtitle)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

class SettingTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(16)
            make.centerY.equalTo(contentView)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).offset(-16)
            make.centerY.equalTo(contentView)
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(8)
        }
        
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .label
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .systemGray
        subtitleLabel.textAlignment = .right
        
        accessoryType = .disclosureIndicator
    }
    
    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle.isEmpty ? "" : subtitle
    }
}

#Preview {
    let navController = UINavigationController(rootViewController: TamaSubViewController())
    return navController
}
