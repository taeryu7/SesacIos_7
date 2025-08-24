//
//  TamaNameChangeViewModel.swift
//  Sesac20250822
//
//  Created by 유태호 on 8/23/25.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol TamaNameChangeViewModelInput {
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var textChanged: PublishSubject<String> { get }
    var saveButtonTap: PublishSubject<String> { get }
}

protocol TamaNameChangeViewModelOutput {
    var initialData: Driver<TamaNameChangeModel> { get }
    var validationMessage: Driver<String> { get }
    var validationColor: Driver<UIColor> { get }
    var isSaveEnabled: Driver<Bool> { get }
    var dismissView: Driver<Void> { get }
}

final class TamaNameChangeViewModel: TamaNameChangeViewModelInput, TamaNameChangeViewModelOutput {
    
    let viewDidLoadTrigger = PublishSubject<Void>()
    let textChanged = PublishSubject<String>()
    let saveButtonTap = PublishSubject<String>()
    
    let initialData: Driver<TamaNameChangeModel>
    let validationMessage: Driver<String>
    let validationColor: Driver<UIColor>
    let isSaveEnabled: Driver<Bool>
    let dismissView: Driver<Void>
    
    private let initialDataSubject = PublishSubject<TamaNameChangeModel>()
    private let dismissSubject = PublishSubject<Void>()
    private let userDefaults = TamagochiUserDefaults.shared
    private let disposeBag = DisposeBag()
    
    init() {
        self.initialData = initialDataSubject.asDriver(onErrorJustReturn: TamaNameChangeModel(
            currentName: "대장",
            validationMessageType: .empty,
            isSaveButtonEnabled: false
        ))
        
        let validation = textChanged
            .map { NameValidationResult.validate($0) }
            .startWith(NameValidationResult(isValid: false, messageType: .empty))
            .share(replay: 1)
        
        self.validationMessage = validation
            .map { TamaNameChangeViewModel.getValidationMessage(for: $0.messageType) }
            .asDriver(onErrorJustReturn: "대장 이름을 입력해주세요")
        
        self.validationColor = validation
            .map { TamaNameChangeViewModel.getValidationColor(for: $0.messageType) }
            .asDriver(onErrorJustReturn: .systemGray)
        
        self.isSaveEnabled = validation
            .map { $0.isValid }
            .asDriver(onErrorJustReturn: false)
        
        self.dismissView = dismissSubject.asDriver(onErrorJustReturn: ())
        
        setupBindings()
    }
    
    private func setupBindings() {
        viewDidLoadTrigger
            .subscribe(onNext: { [weak self] in
                self?.loadCurrentName()
            })
            .disposed(by: disposeBag)
        
        saveButtonTap
            .subscribe(onNext: { [weak self] name in
                self?.handleSaveButton(name: name)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadCurrentName() {
        let currentName = userDefaults.loadTamagochiName()
        let validationResult = NameValidationResult.validate(currentName)
        
        let model = TamaNameChangeModel(
            currentName: currentName,
            validationMessageType: validationResult.messageType,
            isSaveButtonEnabled: validationResult.isValid
        )
        
        initialDataSubject.onNext(model)
    }
    
    private func handleSaveButton(name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let validationResult = NameValidationResult.validate(trimmedName)
        
        guard validationResult.isValid else { return }
        
        userDefaults.saveTamagochiName(trimmedName)
        dismissSubject.onNext(())
    }
    
    private func getValidationMessage(for type: ValidationMessageType) -> String {
        return TamaNameChangeViewModel.getValidationMessage(for: type)
    }
    
    private func getValidationColor(for type: ValidationMessageType) -> UIColor {
        return TamaNameChangeViewModel.getValidationColor(for: type)
    }
    
    private static func getValidationMessage(for type: ValidationMessageType) -> String {
        switch type {
        case .empty:
            return "대장 이름을 입력해주세요"
        case .tooShort:
            return "대장 이름은 2글자 이상이어야 합니다"
        case .tooLong:
            return "대장 이름은 6글자 이하여야 합니다"
        case .valid:
            return "사용 가능한 이름입니다"
        }
    }
    
    private static func getValidationColor(for type: ValidationMessageType) -> UIColor {
        switch type {
        case .empty:
            return .systemGray
        case .tooShort, .tooLong:
            return .systemRed
        case .valid:
            return .systemGreen
        }
    }
}
