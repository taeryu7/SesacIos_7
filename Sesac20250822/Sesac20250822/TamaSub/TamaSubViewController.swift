//
//  TamaSubViewController.swift
//  20250708SeSacReport
//
//  Created by 유태호 on 7/9/25.
//

import UIKit
import SnapKit

class TamaSubViewController: UIViewController {
    
    let tableView = UITableView()
    
    // ViewModel
    private let viewModel = TamaSubViewModel()
    
    // 데이터
    private var settingItems: [TamaSubModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        setupNavigationBar()
        setupTableView()
        bindViewModel()
        
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    // ViewModel 바인딩
    private func bindViewModel() {
        viewModel.settingItems = { [weak self] items in
            DispatchQueue.main.async {
                self?.settingItems = items
                self?.tableView.reloadData()
            }
        }
        
        viewModel.showNameChangeScreen = { [weak self] in
            DispatchQueue.main.async {
                self?.showNameChangeScreen()
            }
        }
        
        viewModel.showTamagochiChangeScreen = { [weak self] in
            DispatchQueue.main.async {
                self?.showTamagochiChangeScreen()
            }
        }
        
        viewModel.showDataResetAlert = { [weak self] in
            DispatchQueue.main.async {
                self?.showDataResetScreen()
            }
        }
    }
    
    private func showNameChangeScreen() {
        let nameChangeVC = TamaNameChangeViewController()
        navigationController?.pushViewController(nameChangeVC, animated: true)
    }
    
    private func showTamagochiChangeScreen() {
        // 현재 데이터 백업
        let currentLevel = TamagochiUserDefaults.shared.loadTamagochiLevel()
        let currentRiceCount = TamagochiUserDefaults.shared.loadRiceCount()
        let currentWaterCount = TamagochiUserDefaults.shared.loadWaterCount()
        let currentName = TamagochiUserDefaults.shared.loadTamagochiName()
        
        let selectVC = TamaSelectViewController()
        
        // 다마고치 변경 클로저
        selectVC.isChangingTamagochi = true
        selectVC.onTamagochiChanged = { [weak self] in
            TamagochiUserDefaults.shared.saveTamagochiData(
                level: currentLevel,
                riceCount: currentRiceCount,
                waterCount: currentWaterCount
            )
            TamagochiUserDefaults.shared.saveTamagochiName(currentName)
            
            // 메인 화면으로 돌아가기
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
            // 모든 UserDefaults 데이터 삭제
            TamagochiUserDefaults.shared.resetAllData()
            
            // 다마고치 선택 화면으로 이동
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectMenu(at: indexPath.row)
    }
}

// 설정 테이블뷰 셀
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
