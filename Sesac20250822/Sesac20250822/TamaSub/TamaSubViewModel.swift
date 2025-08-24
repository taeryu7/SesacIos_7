//
//  TamaSubViewModel.swift
//  Sesac20250822
//
//  Created by 유태호 on 8/23/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol TamaSubViewModelInput {
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var viewWillAppearTrigger: PublishSubject<Void> { get }
    var menuSelection: PublishSubject<Int> { get }
}

protocol TamaSubViewModelOutput {
    var settingItems: Driver<[TamaSubModel]> { get }
    var showNameChangeScreen: Driver<Void> { get }
    var showTamagochiChangeScreen: Driver<Void> { get }
    var showDataResetAlert: Driver<Void> { get }
}

final class TamaSubViewModel: TamaSubViewModelInput, TamaSubViewModelOutput {
    
    let viewDidLoadTrigger = PublishSubject<Void>()
    let viewWillAppearTrigger = PublishSubject<Void>()
    let menuSelection = PublishSubject<Int>()
    
    let settingItems: Driver<[TamaSubModel]>
    let showNameChangeScreen: Driver<Void>
    let showTamagochiChangeScreen: Driver<Void>
    let showDataResetAlert: Driver<Void>
    
    private let settingItemsSubject = BehaviorSubject<[TamaSubModel]>(value: [])
    private let showNameChangeScreenSubject = PublishSubject<Void>()
    private let showTamagochiChangeScreenSubject = PublishSubject<Void>()
    private let showDataResetAlertSubject = PublishSubject<Void>()
    
    private let userDefaults = TamagochiUserDefaults.shared
    private let disposeBag = DisposeBag()
    
    init() {
        self.settingItems = settingItemsSubject.asDriver(onErrorJustReturn: [])
        self.showNameChangeScreen = showNameChangeScreenSubject.asDriver(onErrorJustReturn: ())
        self.showTamagochiChangeScreen = showTamagochiChangeScreenSubject.asDriver(onErrorJustReturn: ())
        self.showDataResetAlert = showDataResetAlertSubject.asDriver(onErrorJustReturn: ())
        
        setupBindings()
    }
    
    private func setupBindings() {
        viewDidLoadTrigger
            .subscribe(onNext: { [weak self] in
                self?.setupMenuItems()
            })
            .disposed(by: disposeBag)
        
        viewWillAppearTrigger
            .subscribe(onNext: { [weak self] in
                self?.setupMenuItems()
            })
            .disposed(by: disposeBag)
        
        menuSelection
            .subscribe(onNext: { [weak self] index in
                self?.handleMenuSelection(at: index)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupMenuItems() {
        let currentName = userDefaults.loadTamagochiName()
        
        let menuItems: [TamaSubModel] = [
            TamaSubModel(menuType: .changeName, subtitle: currentName),
            TamaSubModel(menuType: .changeTamagochi),
            TamaSubModel(menuType: .resetData)
        ]
        
        settingItemsSubject.onNext(menuItems)
    }
    
    private func handleMenuSelection(at index: Int) {
        let currentItems = try! settingItemsSubject.value()
        guard index < currentItems.count else { return }
        
        let selectedMenu = currentItems[index]
        
        switch selectedMenu.menuType {
        case .changeName:
            showNameChangeScreenSubject.onNext(())
        case .changeTamagochi:
            showTamagochiChangeScreenSubject.onNext(())
        case .resetData:
            showDataResetAlertSubject.onNext(())
        }
    }
}
