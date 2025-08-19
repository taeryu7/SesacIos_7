//
//  MBTIModel.swift
//  SesacWeek7
//
//  Created by 유태호 on 8/9/25.
//

import Foundation

struct Profile {
    var profileImageIndex: Int
    var nickname: String
    var mbtiType: MBTIType
    
    var isComplete: Bool {
        return !nickname.isEmpty && mbtiType.isComplete
    }
}

struct MBTIType {
    var E_I: MBTIOption?  // E 또는 I
    var S_N: MBTIOption?  // S 또는 N
    var T_F: MBTIOption?  // T 또는 F
    var J_P: MBTIOption?  // J 또는 P
    
    var isComplete: Bool {
        return E_I != nil && S_N != nil && T_F != nil && J_P != nil
    }
    
    var displayText: String {
        guard isComplete else { return "" }
        return "\(E_I!.rawValue)\(S_N!.rawValue)\(T_F!.rawValue)\(J_P!.rawValue)"
    }
}

enum MBTIOption: String, CaseIterable {
    case E, I, S, N, T, F, J, P
}

enum MBTICategory: Int, CaseIterable {
    case E_I = 0
    case S_N = 1
    case T_F = 2
    case J_P = 3
    
    var options: [MBTIOption] {
        switch self {
        case .E_I: return [.E, .I]
        case .S_N: return [.S, .N]
        case .T_F: return [.T, .F]
        case .J_P: return [.J, .P]
        }
    }
}

struct NicknameValidationResult {
    let isValid: Bool
    let message: String
    let isHidden: Bool
}
