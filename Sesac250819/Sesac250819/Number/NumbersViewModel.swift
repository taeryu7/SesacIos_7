//
//  NumbersViewModel.swift
//  Sesac250819
//
//  Created by 유태호 on 8/21/25.
//

import Foundation
import RxSwift
import RxCocoa

final class NumbersViewModel {
    
    struct Input {
        let number1Text: Observable<String>
        let number2Text: Observable<String>
        let number3Text: Observable<String>
    }
    
    struct Output {
        let resultText: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let resultText = Observable.combineLatest(
            input.number1Text,
            input.number2Text,
            input.number3Text
        ) { textValue1, textValue2, textValue3 -> Int in
            let number1 = Int(textValue1) ?? 0
            let number2 = Int(textValue2) ?? 0
            let number3 = Int(textValue3) ?? 0
            return number1 + number2 + number3
        }
        .map { $0.description }
        .asDriver(onErrorJustReturn: "0")
        
        return Output(resultText: resultText)
    }
}
