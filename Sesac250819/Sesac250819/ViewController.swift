//
//  ViewController.swift
//  Sesac250819
//
//  Created by 유태호 on 8/19/25.
//

import UIKit

class ViewController: UIViewController {
    
    private let numbersViewButton = UIButton(type: .system)
    private let simpleTableViewButton = UIButton(type: .system)
    private let simpleValidationViewButton = UIButton(type: .system)
    
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
        
        view.addSubview(numbersViewButton)
        view.addSubview(simpleTableViewButton)
        view.addSubview(simpleValidationViewButton)
        
        numbersViewButton.translatesAutoresizingMaskIntoConstraints = false
        simpleTableViewButton.translatesAutoresizingMaskIntoConstraints = false
        simpleValidationViewButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            numbersViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            numbersViewButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            numbersViewButton.widthAnchor.constraint(equalToConstant: 200),
            numbersViewButton.heightAnchor.constraint(equalToConstant: 50),
            
            simpleTableViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            simpleTableViewButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            simpleTableViewButton.widthAnchor.constraint(equalToConstant: 200),
            simpleTableViewButton.heightAnchor.constraint(equalToConstant: 50),
            
            simpleValidationViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            simpleValidationViewButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80),
            simpleValidationViewButton.widthAnchor.constraint(equalToConstant: 200),
            simpleValidationViewButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func numbersViewButtonTapped() {
        let numbersViewController = NumbersViewController()
        let navigationController = UINavigationController(rootViewController: numbersViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc private func simpleTableViewButtonTapped() {
        print("SimpleTableView 버튼이 눌렸습니다")
    }
    
    @objc private func simpleValidationViewButtonTapped() {
        print("SimpleValidationView 버튼이 눌렸습니다")
    }
}
