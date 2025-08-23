//
//  TamaSelectViewModel.swift
//  Sesac20250822
//
//  Created by 유태호 on 8/23/25.
//

import Foundation

protocol TamaSelectViewModelInput {
    func viewDidLoad()
    func activeTamagochiTapped(at index: Int)
    func startButtonTapped()
}

protocol TamaSelectViewModelOutput {
    var selectModel: ((TamaSelectModel) -> Void)? { get set }
    var showTamaDetailPopup: ((String, Bool) -> Void)? { get set }
    var showAlert: ((String, String) -> Void)? { get set }
    var navigateToMain: (() -> Void)? { get set }
    var dismissToMain: (() -> Void)? { get set }
}

final class TamaSelectViewModel: TamaSelectViewModelInput, TamaSelectViewModelOutput {
    
    // 출력 프로퍼티들
    var selectModel: ((TamaSelectModel) -> Void)?
    var showTamaDetailPopup: ((String, Bool) -> Void)?
    var showAlert: ((String, String) -> Void)?
    var navigateToMain: (() -> Void)?
    var dismissToMain: (() -> Void)?
    
    // 비공개 프로퍼티들
    private var selectedTamagochiType: String?
    private var isChangingMode: Bool
    private var onTamagochiChanged: (() -> Void)?
    private let userDefaults = TamagochiUserDefaults.shared
    
    // 초기화
    init(isChangingMode: Bool = false, onTamagochiChanged: (() -> Void)? = nil) {
        self.isChangingMode = isChangingMode
        self.onTamagochiChanged = onTamagochiChanged
    }
    
    // 입력 메서드들
    func viewDidLoad() {
        let model = TamaSelectModel(isChangingMode: isChangingMode)
        selectModel?(model)
    }
    
    func activeTamagochiTapped(at index: Int) {
        guard index < TamagochiType.allCases.count else { return }
        
        let selectedType = TamagochiType.allCases[index]
        showTamaDetailPopup?(selectedType.activeImageName, isChangingMode)
    }
    
    func startButtonTapped() {
        guard let selectedType = selectedTamagochiType else {
            showAlert?("알림", "다마고치를 선택해주세요!")
            return
        }
        
        processSelectedTamagochi(selectedType)
    }
    
    // 외부에서 선택된 다마고치 설정
    func setSelectedTamagochi(_ type: String) {
        selectedTamagochiType = type
        processSelectedTamagochi(type)
    }
}

// 비공개 메서드들
private extension TamaSelectViewModel {
    
    func processSelectedTamagochi(_ selectedType: String) {
        // 선택된 다마고치 저장
        userDefaults.saveSelectedTamagochiType(selectedType)
        
        if isChangingMode {
            // 다마고치 변경 모드일 때
            onTamagochiChanged?()
            dismissToMain?()
        } else {
            // 최초 선택 모드일 때
            userDefaults.setFirstLaunchCompleted()
            navigateToMain?()
        }
    }
}
