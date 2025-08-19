//
//  MBTIViewModel.swift
//  SesacWeek7
//
//  Created by 유태호 on 8/9/25.
//

import Foundation

class MBTIViewModel {
    
    private var profile = Profile(
        profileImageIndex: 0,
        nickname: "",
        mbtiType: MBTIType()
    ) {
        didSet {
            updateObservables()
        }
    }
    
    var profileImageIndex = Field("0")
    var validationMessage = Field("")
    var validationColor = Field("red")
    var validationHidden = Field("true")
    var completeButtonEnabled = Field("false")
    var mbtiState = Field("")
    var showSuccessAlert = Field("false")
    
    init() {
        print("MBTIViewModel 초기화")
        // 초기 랜덤 프로필 이미지 설정
        profile.profileImageIndex = generateRandomProfileImageIndex()
        updateObservables()
    }
    
    func updateNickname(_ nickname: String) {
        profile.nickname = nickname
        let result = validateNickname(nickname)
        
        // Observable Fields 업데이트
        validationMessage.text = result.message
        validationColor.text = result.isValid ? "blue" : "red"
        validationHidden.text = result.isHidden ? "true" : "false"
    }
    
    func updateProfileImage(_ index: Int) {
        profile.profileImageIndex = index
        updateObservables()
    }
    
    func selectMBTI(category: MBTICategory, option: MBTIOption) {
        selectMBTIOption(current: &profile.mbtiType, category: category, option: option)
        updateMBTIState()
    }
    
    func isOptionSelected(category: MBTICategory, option: MBTIOption) -> Bool {
        switch category {
        case .E_I: return profile.mbtiType.E_I == option
        case .S_N: return profile.mbtiType.S_N == option
        case .T_F: return profile.mbtiType.T_F == option
        case .J_P: return profile.mbtiType.J_P == option
        }
    }
    
    func profileImageTapped() {
        // 다음 프로필 이미지로 변경 (임시 구현)
        profile.profileImageIndex = (profile.profileImageIndex + 1) % 12
    }
    
    func completeButtonTapped() {
        guard profile.isComplete else { return }
        
        // 완료 처리 로직
        print("프로필 설정 완료: \(profile)")
        showSuccessAlert.text = "true"
    }
    
    func getCurrentProfileImageIndex() -> Int {
        return profile.profileImageIndex
    }
    
    func getCurrentMBTI() -> MBTIType {
        return profile.mbtiType
    }
    
    
    private func updateObservables() {
        profileImageIndex.text = "\(profile.profileImageIndex)"
        completeButtonEnabled.text = profile.isComplete ? "true" : "false"
        updateMBTIState()
    }
    
    private func updateMBTIState() {
        // MBTI 상태를 JSON 형태로 인코딩
        let mbtiData: [String: String?] = [
            "E_I": profile.mbtiType.E_I?.rawValue,
            "S_N": profile.mbtiType.S_N?.rawValue,
            "T_F": profile.mbtiType.T_F?.rawValue,
            "J_P": profile.mbtiType.J_P?.rawValue
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: mbtiData),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            mbtiState.text = jsonString
        }
    }
    
    private func validateNickname(_ nickname: String) -> NicknameValidationResult {
        // 빈 문자열일 경우 레이블 숨김
        if nickname.isEmpty {
            return NicknameValidationResult(
                isValid: false,
                message: "",
                isHidden: true
            )
        }
        
        // 길이 체크 (2-10글자 미만)
        if nickname.count < 2 || nickname.count >= 10 {
            return NicknameValidationResult(
                isValid: false,
                message: "2글자 이상 10글자 미만으로 작성해주세요",
                isHidden: false
            )
        }
        
        // 특수문자 체크
        let forbiddenCharacters = ["@", "#", "$", "%"]
        for character in forbiddenCharacters {
            if nickname.contains(character) {
                return NicknameValidationResult(
                    isValid: false,
                    message: "닉네임에 @, #, $, % 는 포함할수 없어요",
                    isHidden: false
                )
            }
        }
        
        // 숫자 체크
        if nickname.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
            return NicknameValidationResult(
                isValid: false,
                message: "닉네임에 숫자는 포함할 수없습니다",
                isHidden: false
            )
        }
        
        // 모든 조건 통과
        return NicknameValidationResult(
            isValid: true,
            message: "사용할 수 있는 닉네임이에요",
            isHidden: false
        )
    }
    
    private func selectMBTIOption(current: inout MBTIType, category: MBTICategory, option: MBTIOption) {
        switch category {
        case .E_I:
            // 같은 옵션 선택시 토글 (취소)
            if current.E_I == option {
                current.E_I = nil
            } else {
                current.E_I = option
            }
            
        case .S_N:
            if current.S_N == option {
                current.S_N = nil
            } else {
                current.S_N = option
            }
            
        case .T_F:
            if current.T_F == option {
                current.T_F = nil
            } else {
                current.T_F = option
            }
            
        case .J_P:
            if current.J_P == option {
                current.J_P = nil
            } else {
                current.J_P = option
            }
        }
    }
    
    private func generateRandomProfileImageIndex() -> Int {
        return Int.random(in: 0...47)
    }
}
