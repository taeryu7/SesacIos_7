//
//  BirthDayViewController.swift
//  MVVMBasic
//
//  Created by Finn on 8/7/25.
//

import UIKit
import SnapKit

enum DateValidationError: Error, LocalizedError {
    case emptyYear
    case emptyMonth
    case emptyDay
    case invalidYearFormat
    case invalidMonthFormat
    case invalidDayFormat
    case yearOutOfRange(min: Int, max: Int)
    case monthOutOfRange(min: Int, max: Int)
    case dayOutOfRange(min: Int, max: Int)
    case invalidDate
    case futureDate
    
    var errorDescription: String? {
        switch self {
        case .emptyYear:
            return "년도를 입력해주세요"
        case .emptyMonth:
            return "월을 입력해주세요"
        case .emptyDay:
            return "일을 입력해주세요"
        case .invalidYearFormat:
            return "올바른 년도 형식을 입력해주세요"
        case .invalidMonthFormat:
            return "올바른 월 형식을 입력해주세요"
        case .invalidDayFormat:
            return "올바른 일 형식을 입력해주세요"
        case .yearOutOfRange(let min, let max):
            return "년도는 \(min)년부터 \(max)년까지 입력 가능합니다"
        case .monthOutOfRange(let min, let max):
            return "월은 \(min)월부터 \(max)월까지 입력 가능합니다"
        case .dayOutOfRange(let min, let max):
            return "일은 \(min)일부터 \(max)일까지 입력 가능합니다"
        case .invalidDate:
            return "존재하지 않는 날짜입니다"
        case .futureDate:
            return "미래 날짜는 입력할 수 없습니다"
        }
    }
}



protocol DateComponentValidator {
    associatedtype ComponentType
    func validate(_ input: String) -> ValidationResult<ComponentType>
}

struct YearValidator: DateComponentValidator {
    typealias ComponentType = Int
    
    private let minYear: Int = 1900
    private let maxYear: Int
    
    init() {
        let currentYear = Calendar.current.component(.year, from: Date())
        self.maxYear = currentYear
    }
    
    func validate(_ input: String) -> ValidationResult<Int> {
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedInput.isEmpty else {
            return .failure(DateValidationError.emptyYear)
        }
        
        guard let year = Int(trimmedInput) else {
            return .failure(DateValidationError.invalidYearFormat)
        }
        
        guard year >= minYear && year <= maxYear else {
            return .failure(DateValidationError.yearOutOfRange(min: minYear, max: maxYear))
        }
        
        return .success(year)
    }
}

struct MonthValidator: DateComponentValidator {
    typealias ComponentType = Int
    
    private let minMonth = 1
    private let maxMonth = 12
    
    func validate(_ input: String) -> ValidationResult<Int> {
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedInput.isEmpty else {
            return .failure(DateValidationError.emptyMonth)
        }
        
        guard let month = Int(trimmedInput) else {
            return .failure(DateValidationError.invalidMonthFormat)
        }
        
        guard month >= minMonth && month <= maxMonth else {
            return .failure(DateValidationError.monthOutOfRange(min: minMonth, max: maxMonth))
        }
        
        return .success(month)
    }
}

struct DayValidator: DateComponentValidator {
    typealias ComponentType = Int
    
    private let minDay = 1
    private let maxDay = 31
    
    func validate(_ input: String) -> ValidationResult<Int> {
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedInput.isEmpty else {
            return .failure(DateValidationError.emptyDay)
        }
        
        guard let day = Int(trimmedInput) else {
            return .failure(DateValidationError.invalidDayFormat)
        }
        
        guard day >= minDay && day <= maxDay else {
            return .failure(DateValidationError.dayOutOfRange(min: minDay, max: maxDay))
        }
        
        return .success(day)
    }
}

struct DateCreator<T> {
    func createDate(year: T, month: T, day: T) -> ValidationResult<Date> where T: BinaryInteger {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = Int(year)
        dateComponents.month = Int(month)
        dateComponents.day = Int(day)
        
        guard let date = calendar.date(from: dateComponents) else {
            return .failure(DateValidationError.invalidDate)
        }
        
        let today = Date()
        if date > today {
            return .failure(DateValidationError.futureDate)
        }
        
        return .success(date)
    }
}

struct DayCalculator {
    func calculateDaysSince(_ date: Date, from referenceDate: Date = Date()) -> Int {
        let timeInterval = referenceDate.timeIntervalSince(date)
        let days = Int(timeInterval / (24 * 60 * 60))
        return days
    }
}

struct AgeCalculator {
    func calculateAge(birthDate: Date, currentDate: Date = Date()) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: currentDate)
        return ageComponents.year ?? 0
    }
}

struct CustomDateComponents {
    let year: Int
    let month: Int
    let day: Int
    let date: Date
    let daysSinceBirth: Int
    let age: Int
    
    init(year: Int, month: Int, day: Int, date: Date, daysSinceBirth: Int, age: Int) {
        self.year = year
        self.month = month
        self.day = day
        self.date = date
        self.daysSinceBirth = daysSinceBirth
        self.age = age
    }
}

class BirthDayViewController: UIViewController {
    
    private let yearValidator = YearValidator()
    private let monthValidator = MonthValidator()
    private let dayValidator = DayValidator()
    private let dateCreator = DateCreator<Int>()
    private let dayCalculator = DayCalculator()
    private let ageCalculator = AgeCalculator()
    
    let yearTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "년도 (1900-2025)"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.text = "년"
        return label
    }()
    
    let monthTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "월 (1-12)"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "월"
        return label
    }()
    
    let dayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "일 (1-31)"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "일"
        return label
    }()
    
    let resultButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("생일 계산하기", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "생년월일을 입력하고 버튼을 눌러주세요"
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
        
        [yearTextField, monthTextField, dayTextField].forEach { textField in
            textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }
    
    func configureHierarchy() {
        view.addSubview(yearTextField)
        view.addSubview(yearLabel)
        view.addSubview(monthTextField)
        view.addSubview(monthLabel)
        view.addSubview(dayTextField)
        view.addSubview(dayLabel)
        view.addSubview(resultButton)
        view.addSubview(resultLabel)
    }
    
    func configureLayout() {
        yearTextField.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.centerY.equalTo(yearTextField)
            make.leading.equalTo(yearTextField.snp.trailing).offset(12)
        }
        
        monthTextField.snp.makeConstraints { make in
            make.top.equalTo(yearTextField.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.centerY.equalTo(monthTextField)
            make.leading.equalTo(monthTextField.snp.trailing).offset(12)
        }
        
        dayTextField.snp.makeConstraints { make in
            make.top.equalTo(monthTextField.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dayTextField)
            make.leading.equalTo(dayTextField.snp.trailing).offset(12)
        }
        
        resultButton.snp.makeConstraints { make in
            make.top.equalTo(dayTextField.snp.bottom).offset(20)
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
        calculateBirthDays()
    }
    
    @objc func textFieldDidChange() {
        resetResult()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func calculateBirthDays() {
        guard let yearText = yearTextField.text,
              let monthText = monthTextField.text,
              let dayText = dayTextField.text else {
            showErrorAlert(DateValidationError.emptyYear)
            return
        }
        
        let yearResult = yearValidator.validate(yearText)
        let monthResult = monthValidator.validate(monthText)
        let dayResult = dayValidator.validate(dayText)
        
        processValidationResults(
            yearResult: yearResult,
            monthResult: monthResult,
            dayResult: dayResult
        )
    }
    
    private func processValidationResults<Y, M, D>(
        yearResult: ValidationResult<Y>,
        monthResult: ValidationResult<M>,
        dayResult: ValidationResult<D>
    ) {
        var errors: [Error] = []
        var year: Int?
        var month: Int?
        var day: Int?
        
        switch yearResult {
        case .success(let y):
            if let y = y as? Int {
                year = y
            }
        case .failure(let error):
            errors.append(error)
        }
        
        switch monthResult {
        case .success(let m):
            if let m = m as? Int {
                month = m
            }
        case .failure(let error):
            errors.append(error)
        }
        
        switch dayResult {
        case .success(let d):
            if let d = d as? Int {
                day = d
            }
        case .failure(let error):
            errors.append(error)
        }
        
        if !errors.isEmpty {
            showErrorAlert(errors.first!)
            return
        }
        
        guard let validYear = year,
              let validMonth = month,
              let validDay = day else {
            showErrorAlert(DateValidationError.invalidDate)
            return
        }
        
        let dateResult = dateCreator.createDate(year: validYear, month: validMonth, day: validDay)
        
        switch dateResult {
        case .success(let birthDate):
            let daysSinceBirth = dayCalculator.calculateDaysSince(birthDate)
            let age = ageCalculator.calculateAge(birthDate: birthDate)
            
            let dateComponents = CustomDateComponents(
                year: validYear,
                month: validMonth,
                day: validDay,
                date: birthDate,
                daysSinceBirth: daysSinceBirth,
                age: age
            )
            
            displayBirthDayResult(dateComponents)
            
        case .failure(let error):
            showErrorAlert(error)
        }
    }
    
    private func displayBirthDayResult(_ dateComponents: CustomDateComponents) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        let formattedDate = formatter.string(from: dateComponents.date)
        
        let message = """
        생년월일: \(formattedDate)
        나이: \(dateComponents.age)세
        오늘 날짜를 기준으로 D+\(dateComponents.daysSinceBirth)일째입니다
        """
        
        resultLabel.text = message
        resultLabel.textColor = .systemGreen
    }
    
    private func resetResult() {
        resultLabel.text = "생년월일을 입력하고 버튼을 눌러주세요"
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
