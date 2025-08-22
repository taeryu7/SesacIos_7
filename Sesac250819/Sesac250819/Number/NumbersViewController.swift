//
//  NumbersViewController.swift
//  Sesac250819
//
//  Created by 유태호 on 8/19/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NumbersViewController: UIViewController {

    let number1TextField = UITextField()
    let number2TextField = UITextField()
    let number3TextField = UITextField()
    let plusLabel = UILabel()
    let separatorView = UIView()
    let resultLabel = UILabel()
    
    private let viewModel = NumbersViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Adding numbers"
        
        configureLayout()
        configure()
        bindViewModel()
    }
    
    @objc func dismissViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    private func bindViewModel() {
        let input = NumbersViewModel.Input(
            number1Text: number1TextField.rx.text.orEmpty.asObservable(),
            number2Text: number2TextField.rx.text.orEmpty.asObservable(),
            number3Text: number3TextField.rx.text.orEmpty.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.resultText
            .drive(resultLabel.rx.text)
            .disposed(by: disposeBag)
    }

    func configure() {
        number1TextField.text = "1"
        number1TextField.borderStyle = .roundedRect
        number1TextField.textAlignment = .right
        number1TextField.keyboardType = .numberPad
        number1TextField.font = .systemFont(ofSize: 14)
        
        number2TextField.text = "2"
        number2TextField.borderStyle = .roundedRect
        number2TextField.textAlignment = .right
        number2TextField.keyboardType = .numberPad
        number2TextField.font = .systemFont(ofSize: 14)
        
        number3TextField.text = "3"
        number3TextField.borderStyle = .roundedRect
        number3TextField.textAlignment = .right
        number3TextField.keyboardType = .numberPad
        number3TextField.font = .systemFont(ofSize: 14)
        
        plusLabel.text = "+"
        plusLabel.font = .systemFont(ofSize: 17)
        plusLabel.textColor = .label
        
        separatorView.backgroundColor = .systemGray3
        
        resultLabel.text = "-1"
        resultLabel.textAlignment = .right
        resultLabel.font = .systemFont(ofSize: 17)
        resultLabel.textColor = .label
    }
    
    func configureLayout() {
        view.addSubview(number1TextField)
        view.addSubview(number2TextField)
        view.addSubview(number3TextField)
        view.addSubview(plusLabel)
        view.addSubview(separatorView)
        view.addSubview(resultLabel)
        
        number3TextField.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(97)
            make.height.equalTo(30)
        }
        
        number2TextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(number3TextField.snp.top).offset(-8)
            make.width.equalTo(97)
            make.height.equalTo(30)
        }
        
        number1TextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(number2TextField.snp.top).offset(-8)
            make.width.equalTo(97)
            make.height.equalTo(30)
        }
        
        plusLabel.snp.makeConstraints { make in
            make.trailing.equalTo(number3TextField.snp.leading).offset(-8)
            make.centerY.equalTo(number3TextField)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(number3TextField.snp.bottom).offset(8)
            make.leading.equalTo(plusLabel)
            make.trailing.equalTo(number3TextField)
            make.height.equalTo(1)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(8)
            make.leading.equalTo(separatorView)
            make.trailing.equalTo(separatorView)
        }
    }
}
