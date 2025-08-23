//
//  TamaDetailViewModel.swift
//  Sesac20250822
//
//  Created by 유태호 on 8/23/25.
//

import Foundation

protocol TamaDetailViewModelInput {
    func viewDidLoad()
    func startButtonTapped()
    func cancelButtonTapped()
    func backgroundTapped()
}

protocol TamaDetailViewModelOutput {
    var detailModel: ((TamaDetailModel) -> Void)? { get set }
    var dismissView: (() -> Void)? { get set }
    var startAction: ((String) -> Void)? { get set }
}

final class TamaDetailViewModel: TamaDetailViewModelInput, TamaDetailViewModelOutput {
    
    var detailModel: ((TamaDetailModel) -> Void)?
    var dismissView: (() -> Void)?
    var startAction: ((String) -> Void)?
    
    private var selectedTamagochiType: String
    private var isChangingMode: Bool
    private var onStartButtonTapped: ((String) -> Void)?
    
    init(selectedTamagochiType: String, isChangingMode: Bool = false, onStartButtonTapped: ((String) -> Void)? = nil) {
        self.selectedTamagochiType = selectedTamagochiType
        self.isChangingMode = isChangingMode
        self.onStartButtonTapped = onStartButtonTapped
    }
    
    func viewDidLoad() {
        updateTamagochiInfo()
    }
    
    func startButtonTapped() {
        startAction?(selectedTamagochiType)
        dismissView?()
    }
    
    func cancelButtonTapped() {
        dismissView?()
    }
    
    func backgroundTapped() {
        dismissView?()
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
        
        detailModel?(model)
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
            "3-9": "차분하고 지혜로운 다마고치입니다.\n깊은 대화를 나눠어요!"
        ]
        return descriptions[selectedTamagochiType] ?? "귀여운 다마고치입니다.\n잘 돌봐주세요!"
    }
    
    func getButtonTitle() -> String {
        return isChangingMode ? "변경하기" : "시작하기"
    }
}
