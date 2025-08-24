//
//  TamaSelectViewModel.swift
//  Sesac20250822
//
//  Created by 유태호 on 8/23/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol TamaSelectViewModelInput {
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var activeTamagochiTap: PublishSubject<Int> { get }
    var selectedTamagochi: PublishSubject<String> { get }
}

protocol TamaSelectViewModelOutput {
    var selectModel: Driver<TamaSelectModel> { get }
    var showTamaDetailPopup: Driver<(String, Bool)> { get }
    var showAlert: Driver<(String, String)> { get }
    var navigateToMain: Driver<Void> { get }
    var dismissToMain: Driver<Void> { get }
}

final class TamaSelectViewModel: TamaSelectViewModelInput, TamaSelectViewModelOutput {
    
    let viewDidLoadTrigger = PublishSubject<Void>()
    let activeTamagochiTap = PublishSubject<Int>()
    let selectedTamagochi = PublishSubject<String>()
    
    let selectModel: Driver<TamaSelectModel>
    let showTamaDetailPopup: Driver<(String, Bool)>
    let showAlert: Driver<(String, String)>
    let navigateToMain: Driver<Void>
    let dismissToMain: Driver<Void>
    
    private let selectModelSubject = PublishSubject<TamaSelectModel>()
    private let showTamaDetailPopupSubject = PublishSubject<(String, Bool)>()
    private let showAlertSubject = PublishSubject<(String, String)>()
    private let navigateToMainSubject = PublishSubject<Void>()
    private let dismissToMainSubject = PublishSubject<Void>()
    
    private var isChangingMode: Bool
    private var onTamagochiChanged: (() -> Void)?
    private let userDefaults = TamagochiUserDefaults.shared
    private let disposeBag = DisposeBag()
    
    init(isChangingMode: Bool = false, onTamagochiChanged: (() -> Void)? = nil) {
        self.isChangingMode = isChangingMode
        self.onTamagochiChanged = onTamagochiChanged
        
        self.selectModel = selectModelSubject.asDriver(onErrorJustReturn: TamaSelectModel(isChangingMode: false))
        self.showTamaDetailPopup = showTamaDetailPopupSubject.asDriver(onErrorJustReturn: ("1-9", false))
        self.showAlert = showAlertSubject.asDriver(onErrorJustReturn: ("", ""))
        self.navigateToMain = navigateToMainSubject.asDriver(onErrorJustReturn: ())
        self.dismissToMain = dismissToMainSubject.asDriver(onErrorJustReturn: ())
        
        setupBindings()
    }
    
    private func setupBindings() {
        viewDidLoadTrigger
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let model = TamaSelectModel(isChangingMode: self.isChangingMode)
                self.selectModelSubject.onNext(model)
            })
            .disposed(by: disposeBag)
        
        activeTamagochiTap
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                guard index < TamagochiType.allCases.count else { return }
                
                let selectedType = TamagochiType.allCases[index]
                self.showTamaDetailPopupSubject.onNext((selectedType.activeImageName, self.isChangingMode))
            })
            .disposed(by: disposeBag)
        
        selectedTamagochi
            .subscribe(onNext: { [weak self] selectedType in
                self?.processSelectedTamagochi(selectedType)
            })
            .disposed(by: disposeBag)
    }
    
    private func processSelectedTamagochi(_ selectedType: String) {
        userDefaults.saveSelectedTamagochiType(selectedType)
        
        if isChangingMode {
            onTamagochiChanged?()
            dismissToMainSubject.onNext(())
        } else {
            userDefaults.setFirstLaunchCompleted()
            navigateToMainSubject.onNext(())
        }
    }
}
