//
//  TamaNameChangeViewModel.swift
//  Sesac20250822
//
//  Created by 유태호 on 8/23/25.
//

import Foundation

protocol TamaNameChangeViewModelInput {
    func viewDidLoad()
    func nameTextChanged(_ text: String)
    func saveButtonTapped(name: String)
}

protocol TamaNameChangeViewModelOutput {
    var initialData: ((TamaNameChangeModel) -> Void)? { get set }
    var validationUpdate: ((ValidationMessageType, Bool) -> Void)? { get set }
    var dismissView: (() -> Void)? { get set }
}

final class TamaNameChangeViewModel: TamaNameChangeViewModelInput, TamaNameChangeViewModelOutput {
    
    // 출력 프로퍼티들
    var initialData: ((TamaNameChangeModel) -> Void)?
    var validationUpdate: ((ValidationMessageType, Bool) -> Void)?
    var dismissView: (() -> Void)?
    
    // 비공개 프로퍼티들
    private let userDefaults = TamagochiUserDefaults.shared
    
    // 입력 메서드들
    func viewDidLoad() {
        loadCurrentName()
    }
    
    func nameTextChanged(_ text: String) {
        let validationResult = NameValidationResult.validate(text)
        validationUpdate?(
            validationResult.messageType,
            validationResult.isValid
        )
    }
    
    func saveButtonTapped(name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let validationResult = NameValidationResult.validate(trimmedName)
        
        guard validationResult.isValid else { return }
        
        // 이름 저장
        userDefaults.saveTamagochiName(trimmedName)
        dismissView?()
    }
}

// 비공개 메서드들
private extension TamaNameChangeViewModel {
    
    func loadCurrentName() {
        let currentName = userDefaults.loadTamagochiName()
        let validationResult = NameValidationResult.validate(currentName)
        
        let model = TamaNameChangeModel(
            currentName: currentName,
            validationMessageType: validationResult.messageType,
            isSaveButtonEnabled: validationResult.isValid
        )
        
        initialData?(model)
    }
}
