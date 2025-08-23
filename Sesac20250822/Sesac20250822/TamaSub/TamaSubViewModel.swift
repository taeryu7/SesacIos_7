//
//  TamaSubViewModel.swift
//  Sesac20250822
//
//  Created by 유태호 on 8/23/25.
//

import Foundation

protocol TamaSubViewModelInput {
    func viewDidLoad()
    func viewWillAppear()
    func didSelectMenu(at index: Int)
}

protocol TamaSubViewModelOutput {
    var settingItems: (([TamaSubModel]) -> Void)? { get set }
    var showNameChangeScreen: (() -> Void)? { get set }
    var showTamagochiChangeScreen: (() -> Void)? { get set }
    var showDataResetAlert: (() -> Void)? { get set }
}

final class TamaSubViewModel: TamaSubViewModelInput, TamaSubViewModelOutput {
    
    var settingItems: (([TamaSubModel]) -> Void)?
    var showNameChangeScreen: (() -> Void)?
    var showTamagochiChangeScreen: (() -> Void)?
    var showDataResetAlert: (() -> Void)?
    
    private let userDefaults = TamagochiUserDefaults.shared
    private var menuItems: [TamaSubModel] = []
    
    func viewDidLoad() {
        setupMenuItems()
        settingItems?(menuItems)
    }
    
    func viewWillAppear() {
        // 이름이 변경될 수 있으므로 다시 로드
        setupMenuItems()
        settingItems?(menuItems)
    }
    
    func didSelectMenu(at index: Int) {
        guard index < menuItems.count else { return }
        
        let selectedMenu = menuItems[index]
        
        switch selectedMenu.menuType {
        case .changeName:
            showNameChangeScreen?()
        case .changeTamagochi:
            showTamagochiChangeScreen?()
        case .resetData:
            showDataResetAlert?()
        }
    }
}

private extension TamaSubViewModel {
    
    func setupMenuItems() {
        let currentName = userDefaults.loadTamagochiName()
        
        menuItems = [
            TamaSubModel(menuType: .changeName, subtitle: currentName),
            TamaSubModel(menuType: .changeTamagochi),
            TamaSubModel(menuType: .resetData)
        ]
    }
}
