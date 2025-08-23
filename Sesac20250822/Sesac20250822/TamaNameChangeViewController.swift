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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        setupNavigationBar()
        loadCurrentName()
        
        // 텍스트필드 실시간 변경 감지
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func saveButtonTapped() {
        guard let newName = nameTextField.text else { return }
        
        let trimmedName = newName.trimmingCharacters(in: .whitespaces)
        
        // 유효성 검사
        if !isValidName(trimmedName) {
            return 
        }
        
        // 이름 저장
        TamagochiUserDefaults.shared.saveTamagochiName(trimmedName)
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func textFieldDidChange() {
        guard let text = nameTextField.text else { return }
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        
        updateValidationMessage(for: trimmedText)
        updateSaveButtonState(for: trimmedText)
    }
    
    private func isValidName(_ name: String) -> Bool {
        return name.count >= 2 && name.count <= 6
    }
    
    private func updateValidationMessage(for name: String) {
        if name.isEmpty {
            validationLabel.text = "대장 이름을 입력해주세요"
            validationLabel.textColor = .systemGray
        } else if name.count < 2 {
            validationLabel.text = "대장 이름은 2글자 이상이어야 합니다"
            validationLabel.textColor = .systemRed
        } else if name.count > 6 {
            validationLabel.text = "대장 이름은 6글자 이하여야 합니다"
            validationLabel.textColor = .systemRed
        } else {
            validationLabel.text = "사용 가능한 이름입니다"
            validationLabel.textColor = .systemGreen
        }
    }
    
    private func updateSaveButtonState(for name: String) {
        let isValid = isValidName(name)
        navigationItem.rightBarButtonItem?.isEnabled = isValid
    }
    
    private func loadCurrentName() {
        let currentName = TamagochiUserDefaults.shared.loadTamagochiName()
        nameTextField.text = currentName
        
        // 초기 유효성 검사
        updateValidationMessage(for: currentName)
        updateSaveButtonState(for: currentName)
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
