//
//  AgeViewController.swift
//  MVVMBasic
//
//  Created by Finn on 8/7/25.
//

import UIKit

enum AgeValidationError: Error, LocalizedError {
    case emptyInput
    case invalidFormat
    case outOfRange(min: Int, max: Int)
    
    var errorDescription: String? {
        switch self {
        case .emptyInput:
            return "나이를 입력해주세요"
        case .invalidFormat:
            return "올바른 숫자를 입력해주세요"
        case .outOfRange(let min, let max):
            return "\(min)세부터 \(max)세까지 입력 가능합니다"
        }
    }
}

enum ValidationResult<T> {
    case success(T)
    case failure(Error)
}

protocol Validator {
    associatedtype T
    func validate(_ input: String) -> ValidationResult<T>
}

struct AgeValidator: Validator {
    typealias T = Int
    
    private let minAge = 1
    private let maxAge = 100
    
    func validate(_ input: String) -> ValidationResult<Int> {
        // 1. 공백 체크
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedInput.isEmpty else {
            return .failure(AgeValidationError.emptyInput)
        }
        
        // 2. 숫자 형식 체크
        guard let age = Int(trimmedInput) else {
            return .failure(AgeValidationError.invalidFormat)
        }
        
        // 3. 범위 체크
        guard age >= minAge && age <= maxAge else {
            return .failure(AgeValidationError.outOfRange(min: minAge, max: maxAge))
        }
        
        return .success(age)
    }
}

struct CategoryGenerator<T: Comparable> {
    let categories: [(range: ClosedRange<T>, description: String)]
    
    func getCategory(for value: T) -> String {
        for category in categories {
            if category.range.contains(value) {
                return category.description
            }
        }
        return "분류 없음"
    }
}

class AgeViewController: UIViewController {
    
    private let ageValidator = AgeValidator()
    private lazy var ageCategoryGenerator = CategoryGenerator<Int>(
        categories: [
            (1...12, "어린이"),
            (13...19, "청소년"),
            (20...39, "청년"),
            (40...59, "중년"),
            (60...100, "노년")
        ]
    )
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "나이를 입력해주세요 (1-100세)"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let resultButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("결과 확인", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "나이를 입력하고 버튼을 눌러주세요"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureHierarchy()
        configureLayout()
        
        resultButton.addTarget(self, action: #selector(resultButtonTapped), for: .touchUpInside)
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func configureHierarchy() {
        view.addSubview(textField)
        view.addSubview(resultButton)
        view.addSubview(errorLabel)
        view.addSubview(label)
    }
    
    func configureLayout() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        resultButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(resultButton.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    @objc func resultButtonTapped() {
        view.endEditing(true)
        processAgeInput()
    }
    
    @objc func textFieldDidChange() {
        hideError()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func processAgeInput() {
        guard let inputText = textField.text else {
            showError(AgeValidationError.emptyInput)
            return
        }
        
        let result = ageValidator.validate(inputText)
        handleValidationResult(result)
    }
    
    private func handleValidationResult<T>(_ result: ValidationResult<T>) {
        switch result {
        case .success(let value):
            if let age = value as? Int {
                showSuccessResult(for: age)
            }
            hideError()
            
        case .failure(let error):
            showError(error)
            clearResult()
        }
    }
    
    private func showSuccessResult(for age: Int) {
        let category = ageCategoryGenerator.getCategory(for: age)
        let message = "입력하신 나이: \(age)세\n연령대: \(category)"
        label.text = message
        label.textColor = .systemGreen
    }
    
    private func showError(_ error: Error) {
        errorLabel.text = error.localizedDescription
        errorLabel.isHidden = false
    }
    
    private func hideError() {
        errorLabel.isHidden = true
        errorLabel.text = nil
    }
    
    private func clearResult() {
        label.text = "나이를 입력하고 버튼을 눌러주세요"
        label.textColor = .label
    }
}
