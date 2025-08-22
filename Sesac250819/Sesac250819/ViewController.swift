//
//  ViewController.swift
//  Sesac250819
//
//  Created by 유태호 on 8/19/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let numbersViewButton = UIButton(type: .system)
    private let simpleTableViewButton = UIButton(type: .system)
    private let simpleValidationViewButton = UIButton(type: .system)
    private let homeworkViewButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        numbersViewButton.setTitle("NumbersView", for: .normal)
        numbersViewButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        numbersViewButton.backgroundColor = .systemBlue
        numbersViewButton.setTitleColor(.white, for: .normal)
        numbersViewButton.layer.cornerRadius = 8
        numbersViewButton.addTarget(self, action: #selector(numbersViewButtonTapped), for: .touchUpInside)
        
        simpleTableViewButton.setTitle("SimpleTableView", for: .normal)
        simpleTableViewButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        simpleTableViewButton.backgroundColor = .systemGreen
        simpleTableViewButton.setTitleColor(.white, for: .normal)
        simpleTableViewButton.layer.cornerRadius = 8
        simpleTableViewButton.addTarget(self, action: #selector(simpleTableViewButtonTapped), for: .touchUpInside)
        
        simpleValidationViewButton.setTitle("SimpleValidationView", for: .normal)
        simpleValidationViewButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        simpleValidationViewButton.backgroundColor = .systemOrange
        simpleValidationViewButton.setTitleColor(.white, for: .normal)
        simpleValidationViewButton.layer.cornerRadius = 8
        simpleValidationViewButton.addTarget(self, action: #selector(simpleValidationViewButtonTapped), for: .touchUpInside)
        
        homeworkViewButton.setTitle("HomeworkView", for: .normal)
        homeworkViewButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        homeworkViewButton.backgroundColor = .systemPurple
        homeworkViewButton.setTitleColor(.white, for: .normal)
        homeworkViewButton.layer.cornerRadius = 8
        homeworkViewButton.addTarget(self, action: #selector(homeworkViewButtonTapped), for: .touchUpInside)
        
        view.addSubview(numbersViewButton)
        view.addSubview(simpleTableViewButton)
        view.addSubview(simpleValidationViewButton)
        view.addSubview(homeworkViewButton)
    }
    
    private func setupConstraints() {
        numbersViewButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-120)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        simpleTableViewButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        simpleValidationViewButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(40)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        homeworkViewButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(120)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    @objc private func numbersViewButtonTapped() {
        let numbersViewController = NumbersViewController()
        navigationController?.pushViewController(numbersViewController, animated: true)
    }
    
    @objc private func simpleTableViewButtonTapped() {
        let tableViewController = SimpleTableViewExampleViewController()
        navigationController?.pushViewController(tableViewController, animated: true)
    }
    
    @objc private func simpleValidationViewButtonTapped() {
        let simpleValidationController = SimpleValidationViewController()
        navigationController?.pushViewController(simpleValidationController, animated: true)
    }
    
    @objc private func homeworkViewButtonTapped() {
        let homeworkViewController = HomeworkViewController()
        navigationController?.pushViewController(homeworkViewController, animated: true)
    }
}
