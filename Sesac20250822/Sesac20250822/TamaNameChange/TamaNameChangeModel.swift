//
//  TamaNameChangeModel.swift
//  Sesac20250822
//
//  Created by 유태호 on 8/23/25.
//

import Foundation

enum ValidationMessageType {
    case empty
    case valid
    case tooShort
    case tooLong
}

struct TamaNameChangeModel {
    let currentName: String
    let validationMessageType: ValidationMessageType
    let isSaveButtonEnabled: Bool
    
    init(currentName: String, validationMessageType: ValidationMessageType, isSaveButtonEnabled: Bool) {
        self.currentName = currentName
        self.validationMessageType = validationMessageType
        self.isSaveButtonEnabled = isSaveButtonEnabled
    }
}

struct NameValidationResult {
    let isValid: Bool
    let messageType: ValidationMessageType
    
    static func validate(_ name: String) -> NameValidationResult {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        
        if trimmedName.isEmpty {
            return NameValidationResult(isValid: false, messageType: .empty)
        } else if trimmedName.count < 2 {
            return NameValidationResult(isValid: false, messageType: .tooShort)
        } else if trimmedName.count > 6 {
            return NameValidationResult(isValid: false, messageType: .tooLong)
        } else {
            return NameValidationResult(isValid: true, messageType: .valid)
        }
    }
}
