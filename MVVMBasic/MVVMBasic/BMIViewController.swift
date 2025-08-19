//
//  BMIViewController.swift
//  MVVMBasic
//
//  Created by Finn on 8/7/25.
//

import UIKit

enum BMIInputError: Error, LocalizedError {
    case emptyHeight
    case emptyWeight
    case invalidHeightFormat
    case invalidWeightFormat
    case heightOutOfRange(min: Double, max: Double)
    case weightOutOfRange(min: Double, max: Double)
    
    var errorDescription: String? {
        switch self {
        case .emptyHeight:
            return "키를 입력해주세요"
        case .emptyWeight:
            return "몸무게를 입력해주세요"
        case .invalidHeightFormat:
            return "올바른 키 형식을 입력해주세요 (예: 170.5)"
        case .invalidWeightFormat:
            return "올바른 몸무게 형식을 입력해주세요 (예: 65.5)"
        case .heightOutOfRange(let min, let max):
            return "키는 \(Int(min))cm ~ \(Int(max))cm 범위로 입력해주세요"
        case .weightOutOfRange(let min, let max):
            return "몸무게는 \(Int(min))kg ~ \(Int(max))kg 범위로 입력해주세요"
        }
    }
}



protocol InputValidator {
    associatedtype InputType
    func validate(_ input: String) -> ValidationResult<InputType>
}

struct HeightValidator: InputValidator {
    typealias InputType = Double
    
    private let minHeight: Double = 100.0
    private let maxHeight: Double = 250.0
    
    func validate(_ input: String) -> ValidationResult<Double> {
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedInput.isEmpty else {
            return .failure(BMIInputError.emptyHeight)
        }
        
        guard let height = Double(trimmedInput) else {
            return .failure(BMIInputError.invalidHeightFormat)
        }
        
        guard height >= minHeight && height <= maxHeight else {
            return .failure(BMIInputError.heightOutOfRange(min: minHeight, max: maxHeight))
        }
        
        return .success(height)
    }
}

struct WeightValidator: InputValidator {
    typealias InputType = Double
    
    private let minWeight: Double = 20.0
    private let maxWeight: Double = 300.0
    
    func validate(_ input: String) -> ValidationResult<Double> {
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedInput.isEmpty else {
            return .failure(BMIInputError.emptyWeight)
        }
        
        guard let weight = Double(trimmedInput) else {
            return .failure(BMIInputError.invalidWeightFormat)
        }
        
        guard weight >= minWeight && weight <= maxWeight else {
            return .failure(BMIInputError.weightOutOfRange(min: minWeight, max: maxWeight))
        }
        
        return .success(weight)
    }
}

struct BMICalculator {
    func calculate(height: Double, weight: Double) -> Double {
        let heightInMeters = height / 100.0
        return weight / (heightInMeters * heightInMeters)
    }
}

struct BMICategoryClassifier<T: Comparable> {
    let categories: [(range: PartialRangeThrough<T>, description: String, color: UIColor)]
    
    init(categories: [(range: PartialRangeThrough<T>, description: String, color: UIColor)]) {
        self.categories = categories
    }
    
    func classify(_ value: T) -> (description: String, color: UIColor) {
        for category in categories {
            if category.range.contains(value) {
                return (category.description, category.color)
            }
        }
        return ("분류 없음", .label)
    }
}

extension BMICategoryClassifier where T == Double {
    static var standard: BMICategoryClassifier<Double> {
        return BMICategoryClassifier(categories: [
            (range: ...18.5, description: "저체중", color: .systemBlue),
            (range: ...23.0, description: "정상", color: .systemGreen),
            (range: ...25.0, description: "과체중", color: .systemOrange),
            (range: ...30.0, description: "비만", color: .systemRed),
            (range: ...Double.greatestFiniteMagnitude, description: "고도비만", color: .systemPurple)
        ])
    }
}

struct BMIData {
    let height: Double
    let weight: Double
    let bmi: Double
    let category: String
    let categoryColor: UIColor
}

class BMIViewController: UIViewController {
    
    private let heightValidator = HeightValidator()
    private let weightValidator = WeightValidator()
    private let bmiCalculator = BMICalculator()
    private let bmiClassifier = BMICategoryClassifier<Double>.standard
    
    let heightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "키를 입력해주세요 (100-250cm)"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    let weightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "몸무게를 입력해주세요 (20-300kg)"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    let resultButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("BMI 계산하기", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "키와 몸무게를 입력하고 버튼을 눌러주세요"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureHierarchy()
        configureLayout()
        
        resultButton.addTarget(self, action: #selector(resultButtonTapped), for: .touchUpInside)
        heightTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        weightTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func configureHierarchy() {
        view.addSubview(heightTextField)
        view.addSubview(weightTextField)
        view.addSubview(resultButton)
        view.addSubview(resultLabel)
    }
    
    func configureLayout() {
        heightTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        weightTextField.snp.makeConstraints { make in
            make.top.equalTo(heightTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        resultButton.snp.makeConstraints { make in
            make.top.equalTo(weightTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(resultButton.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    @objc func resultButtonTapped() {
        view.endEditing(true)
        calculateBMI()
    }
    
    @objc func textFieldDidChange() {
        resetResult()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func calculateBMI() {
        guard let heightText = heightTextField.text,
              let weightText = weightTextField.text else {
            showErrorAlert(BMIInputError.emptyHeight)
            return
        }
        
        let heightResult = heightValidator.validate(heightText)
        let weightResult = weightValidator.validate(weightText)
        
        processValidationResults(heightResult: heightResult, weightResult: weightResult)
    }
    
    private func processValidationResults<H, W>(heightResult: ValidationResult<H>, weightResult: ValidationResult<W>) {
        var errors: [Error] = []
        var height: Double?
        var weight: Double?
        
        switch heightResult {
        case .success(let h):
            if let h = h as? Double {
                height = h
            }
        case .failure(let error):
            errors.append(error)
        }
        
        switch weightResult {
        case .success(let w):
            if let w = w as? Double {
                weight = w
            }
        case .failure(let error):
            errors.append(error)
        }
        
        if !errors.isEmpty {
            showErrorAlert(errors.first!)
            return
        }
        
        guard let validHeight = height, let validWeight = weight else {
            showErrorAlert(BMIInputError.emptyHeight)
            return
        }
        
        let bmi = bmiCalculator.calculate(height: validHeight, weight: validWeight)
        let (category, color) = bmiClassifier.classify(bmi)
        
        let bmiData = BMIData(
            height: validHeight,
            weight: validWeight,
            bmi: bmi,
            category: category,
            categoryColor: color
        )
        
        displayBMIResult(bmiData)
    }
    
    private func displayBMIResult(_ data: BMIData) {
        let message = """
        키: \(String(format: "%.1f", data.height))cm
        몸무게: \(String(format: "%.1f", data.weight))kg
        BMI: \(String(format: "%.1f", data.bmi))
        분류: \(data.category)
        """
        
        resultLabel.text = message
        resultLabel.textColor = data.categoryColor
    }
    
    private func resetResult() {
        resultLabel.text = "키와 몸무게를 입력하고 버튼을 눌러주세요"
        resultLabel.textColor = .label
    }
    
    private func showErrorAlert(_ error: Error) {
        let alert = UIAlertController(
            title: "입력 오류",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
