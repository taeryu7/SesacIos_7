//
//  TamaNameChangeViewController.swift
//  Sesac20250822
//
//  Created by 유태호 on 8/22/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TamaNameChangeViewController: UIViewController {
    
    let nameTextField = UITextField()
    let separatorLine = UIView()
    let validationLabel = UILabel()
    
    private let viewModel = TamaNameChangeViewModel()
    private let disposeBag = DisposeBag()
    private var saveBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        setupNavigationBar()
        bindViewModel()
        
        viewModel.viewDidLoadTrigger.onNext(())
    }
    
    private func bindViewModel() {
        nameTextField.rx.text.orEmpty
            .bind(to: viewModel.textChanged)
            .disposed(by: disposeBag)
        
        saveBarButton.rx.tap
            .withLatestFrom(nameTextField.rx.text.orEmpty)
            .bind(to: viewModel.saveButtonTap)
            .disposed(by: disposeBag)
        
        viewModel.initialData
            .drive(onNext: { [weak self] model in
                self?.nameTextField.text = model.currentName
            })
            .disposed(by: disposeBag)
        
        viewModel.validationMessage
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.validationColor
            .drive(validationLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        viewModel.isSaveEnabled
            .drive(saveBarButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.dismissView
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension TamaNameChangeViewController {
    
    func configureHierarchy() {
        view.addSubview(nameTextField)
        view.addSubview(separatorLine)
        view.addSubview(validationLabel)
    }
    
    func configureLayout() {
        view.backgroundColor = .systemBackground
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(50)
        }
        nameTextField.placeholder = "대장 이름을 입력하세요 (2~6글자)"
        nameTextField.font = UIFont.systemFont(ofSize: 16)
        nameTextField.textColor = .label
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.borderStyle = .none
        
        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom)
            make.leading.trailing.equalTo(nameTextField)
            make.height.equalTo(1)
        }
        separatorLine.backgroundColor = .systemGray4
        
        validationLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorLine.snp.bottom).offset(8)
            make.leading.trailing.equalTo(nameTextField)
        }
        validationLabel.font = UIFont.systemFont(ofSize: 14)
        validationLabel.textColor = .systemGray
        validationLabel.text = "대장 이름을 입력해주세요"
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "이름 변경"
        
        saveBarButton = UIBarButtonItem(
            title: "저장",
            style: .done,
            target: nil,
            action: nil
        )
        navigationItem.rightBarButtonItem = saveBarButton
        
        navigationController?.navigationBar.tintColor = UIColor.label
    }
}

#Preview {
    let navController = UINavigationController(rootViewController: TamaNameChangeViewController())
    return navController
}
