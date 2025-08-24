//
//  TamaDetailViewModel.swift
//  Sesac20250822
//
//  Created by 유태호 on 8/23/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol TamaDetailViewModelInput {
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var startButtonTap: PublishSubject<Void> { get }
    var cancelButtonTap: PublishSubject<Void> { get }
    var backgroundTap: PublishSubject<Void> { get }
}

protocol TamaDetailViewModelOutput {
    var detailModel: Driver<TamaDetailModel> { get }
    var dismissView: Driver<Void> { get }
    var startAction: Driver<String> { get }
}

final class TamaDetailViewModel: TamaDetailViewModelInput, TamaDetailViewModelOutput {
    
    let viewDidLoadTrigger = PublishSubject<Void>()
    let startButtonTap = PublishSubject<Void>()
    let cancelButtonTap = PublishSubject<Void>()
    let backgroundTap = PublishSubject<Void>()
    
    let detailModel: Driver<TamaDetailModel>
    let dismissView: Driver<Void>
    let startAction: Driver<String>
    
    private let detailModelSubject = PublishSubject<TamaDetailModel>()
    private let dismissSubject = PublishSubject<Void>()
    private let startActionSubject = PublishSubject<String>()
    
    private var selectedTamagochiType: String
    private var isChangingMode: Bool
    private let disposeBag = DisposeBag()
    
    init(selectedTamagochiType: String, isChangingMode: Bool = false) {
        self.selectedTamagochiType = selectedTamagochiType
        self.isChangingMode = isChangingMode
        
        self.detailModel = detailModelSubject.asDriver(onErrorJustReturn: TamaDetailModel(
            tamagochiType: "1-9",
            name: "다마고치",
            description: "귀여운 다마고치입니다.",
            buttonTitle: "시작하기"
        ))
        self.dismissView = dismissSubject.asDriver(onErrorJustReturn: ())
        self.startAction = startActionSubject.asDriver(onErrorJustReturn: "")
        
        setupBindings()
    }
    
    private func setupBindings() {
        viewDidLoadTrigger
            .subscribe(onNext: { [weak self] in
                self?.updateTamagochiInfo()
            })
            .disposed(by: disposeBag)
        
        startButtonTap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.startActionSubject.onNext(self.selectedTamagochiType)
                self.dismissSubject.onNext(())
            })
            .disposed(by: disposeBag)
        
        cancelButtonTap
            .subscribe(onNext: { [weak self] in
                self?.dismissSubject.onNext(())
            })
            .disposed(by: disposeBag)
        
        backgroundTap
            .subscribe(onNext: { [weak self] in
                self?.dismissSubject.onNext(())
            })
            .disposed(by: disposeBag)
    }
}

private extension TamaDetailViewModel {
    
    func updateTamagochiInfo() {
        let name = getTamagochiName()
        let description = getTamagochiDescription()
        let buttonTitle = getButtonTitle()
        
        let model = TamaDetailModel(
            tamagochiType: selectedTamagochiType,
            name: name,
            description: description,
            buttonTitle: buttonTitle
        )
        
        detailModelSubject.onNext(model)
    }
    
    func getTamagochiName() -> String {
        let names: [String: String] = [
            "1-9": "따끔따끔 다마고치",
            "2-9": "방실방실 다마고치",
            "3-9": "반짝반짝 다마고치"
        ]
        return names[selectedTamagochiType] ?? "다마고치"
    }
    
    func getTamagochiDescription() -> String {
        if isChangingMode {
            return getChangingModeDescription()
        } else {
            return getInitialModeDescription()
        }
    }
    
    func getChangingModeDescription() -> String {
        let descriptions: [String: String] = [
            "1-9": "따끔따끔 다마고치로 변경하시겠습니까?\n현재 레벨과 데이터는 유지됩니다.",
            "2-9": "방실방실 다마고치로 변경하시겠습니까?\n현재 레벨과 데이터는 유지됩니다.",
            "3-9": "반짝반짝 다마고치로 변경하시겠습니까?\n현재 레벨과 데이터는 유지됩니다."
        ]
        return descriptions[selectedTamagochiType] ?? "귀여운 다마고치입니다.\n잘 돌봐주세요!"
    }
    
    func getInitialModeDescription() -> String {
        let descriptions: [String: String] = [
            "1-9": "따뜻한 마음을 가진 다마고치입니다.\n함께 즐거운 시간을 보내요!",
            "2-9": "활발하고 에너지 넘치는 다마고치입니다.\n매일 새로운 모험을 떠나요!",
            "3-9": "차분하고 지혜로운 다마고치입니다.\n깊은 대화를 나눠 어요!"
        ]
        return descriptions[selectedTamagochiType] ?? "귀여운 다마고치입니다.\n잘 돌봐주세요!"
    }
    
    func getButtonTitle() -> String {
        return isChangingMode ? "변경하기" : "시작하기"
    }
}
