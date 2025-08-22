//
//  SimpleValidationViewModel.swift
//  Sesac250819
//
//  Created by 유태호 on 8/21/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SimpleValidationViewModel {
    
    private let minimalUsernameLength = 5
    private let minimalPasswordLength = 5
    
    /// Observable<String>: 연속적 데이터 변경이 있거나 값 중심일때 사용
    /// ControlEvent<Void>: 불연속적 이벤트 신호가 있을때, 시점 중심의 상황일때, UI 안전성을 보장할때 사용 이라는데....
    /// 일단 돌아는 가긴하는데... 맞나?
    /// 이게 맞는 접근방법인지? 맞는 이해인지? 여쭤볼것
    
    
    struct Input {
        let usernameText: Observable<String>
        let passwordText: Observable<String>
        let buttonTap: ControlEvent<Void>
    }
    
    struct Output {
        let usernameValid: Driver<Bool>
        let passwordValid: Driver<Bool>
        let passwordEnabled: Driver<Bool>
        let buttonEnabled: Driver<Bool>
        let usernameErrorHidden: Driver<Bool>
        let passwordErrorHidden: Driver<Bool>
        let showAlert: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        // Username 유효성 검증
        let usernameValid = input.usernameText
            .map { [weak self] text in
                guard let self = self else { return false }
                return text.count >= self.minimalUsernameLength
            }
            .asDriver(onErrorJustReturn: false)
        
        // Password 유효성 검증
        let passwordValid = input.passwordText
            .map { [weak self] text in
                guard let self = self else { return false }
                return text.count >= self.minimalPasswordLength
            }
            .asDriver(onErrorJustReturn: false)
        
        // 전체 유효성 검증
        let everythingValid = Driver.combineLatest(usernameValid, passwordValid) { $0 && $1 }
        
        // 버튼 탭 시 알림 표시
        let showAlert = input.buttonTap
            .asDriver()
        
        return Output(
            usernameValid: usernameValid,
            passwordValid: passwordValid,
            passwordEnabled: usernameValid,
            buttonEnabled: everythingValid,
            usernameErrorHidden: usernameValid,
            passwordErrorHidden: passwordValid,
            showAlert: showAlert
        )
    }
}
