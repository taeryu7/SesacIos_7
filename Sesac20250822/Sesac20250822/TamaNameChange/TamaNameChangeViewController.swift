//
//  TamaNameChangeViewController.swift
//  Sesac20250822
//
//  Created by 유태호 on 8/22/25.
//

import UIKit
import SnapKit

class TamaNameChangeViewController: UIViewController {
    
    let nameTextField = UITextField()
    let separatorLine = UIView()
    let validationLabel = UILabel()
    
    // ViewModel
    private let viewModel = TamaNameChangeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        setupNavigationBar()
        bindViewModel()
        
        // 텍스트필드 실시간 변경 감지
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        viewModel.viewDidLoad()
    }
    
    // ViewModel 바인딩
    private func bindViewModel() {
        viewModel.initialData = { [weak self] model in
            DispatchQueue.main.async {
                self?.updateUI(with: model)
            }
        }
        
        viewModel.validationUpdate = { [weak self] messageType, isEnabled in
            DispatchQueue.main.async {
                self?.updateValidation(messageType: messageType, isEnabled: isEnabled)
            }
        }
        
        viewModel.dismissView = { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // UI 업데이트
    private func updateUI(with model: TamaNameChangeModel) {
        nameTextField.text = model.currentName
        updateValidation(messageType: model.validationMessageType, isEnabled: model.isSaveButtonEnabled)
    }
    
    private func updateValidation(messageType: ValidationMessageType, isEnabled: Bool) {
        let (message, color) = getValidationDisplay(for: messageType)
        validationLabel.text = message
        validationLabel.textColor = color
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }
    
    private func getValidationDisplay(for type: ValidationMessageType) -> (String, UIColor) {
        switch type {
        case .empty:
            return ("대장 이름을 입력해주세요", .systemGray)
        case .tooShort:
            return ("대장 이름은 2글자 이상이어야 합니다", .systemRed)
        case .tooLong:
            return ("대장 이름은 6글자 이하여야 합니다", .systemRed)
        case .valid:
            return ("사용 가능한 이름입니다", .systemGreen)
        }
    }
    
    @objc private func saveButtonTapped() {
        guard let newName = nameTextField.text else { return }
        viewModel.saveButtonTapped(name: newName)
    }
    
    @objc private func textFieldDidChange() {
        guard let text = nameTextField.text else { return }
        viewModel.nameTextChanged(text)
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
        
        // 이름 텍스트필드
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
        
        // 구분선
        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom)
            make.leading.trailing.equalTo(nameTextField)
            make.height.equalTo(1)
        }
        separatorLine.backgroundColor = .systemGray4
        
        // 유효성 검사 라벨
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
        
        // 저장 버튼
        let saveBarButton = UIBarButtonItem(
            title: "저장",
            style: .done,
            target: self,
            action: #selector(saveButtonTapped)
        )
        navigationItem.rightBarButtonItem = saveBarButton
        
        navigationController?.navigationBar.tintColor = UIColor.label
    }
}

#Preview {
    let navController = UINavigationController(rootViewController: TamaNameChangeViewController())
    return navController
}
