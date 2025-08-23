//
//  TamaMainViewModel.swift
//  Sesac20250822
//
//  Created by 유태호 on 8/23/25.
//

import Foundation

protocol TamaMainViewModelInput {
    func viewDidLoad()
    func viewWillAppear()
    func feedButtonTapped(inputText: String)
    func waterButtonTapped(inputText: String)
}

protocol TamaMainViewModelOutput {
    var tamagochiModel: ((TamagochiModel) -> Void)? { get set }
    var bubbleMessage: ((String) -> Void)? { get set }
    var showAlert: ((String, String) -> Void)? { get set }
    var clearTextField: ((TextFieldType) -> Void)? { get set }
}

enum TextFieldType {
    case feed
    case water
}

final class TamaMainViewModel: TamaMainViewModelInput, TamaMainViewModelOutput {
    
    var tamagochiModel: ((TamagochiModel) -> Void)?
    var bubbleMessage: ((String) -> Void)?
    var showAlert: ((String, String) -> Void)?
    var clearTextField: ((TextFieldType) -> Void)?
    
    private var model: TamagochiModel
    private let userDefaults = TamagochiUserDefaults.shared
    
    init() {
        self.model = TamagochiModel()
    }
    
    func viewDidLoad() {
        loadTamagochiData()
        updateRandomMessage()
    }
    
    func viewWillAppear() {
        loadOwnerName()
        loadTamagochiType()
        updateRandomMessage()
        notifyModelUpdate()
    }
    
    func feedButtonTapped(inputText: String) {
        let inputCount = parseInput(inputText, defaultValue: 1)
        
        guard let count = inputCount else {
            showAlert?("알림", "올바른 숫자를 입력해주세요")
            return
        }
        
        guard count <= 99 else {
            showAlert?("알림", "다마고치가 한 번에 먹을 수 있는 밥의 양은 99개까지입니다")
            return
        }
        
        model.riceCount += count
        clearTextField?(.feed)
        updateTamagochiLevel()
        saveTamagochiData()
        updateFeedMessage(inputCount: count)
    }
    
    func waterButtonTapped(inputText: String) {
        let inputCount = parseInput(inputText, defaultValue: 1)
        
        guard let count = inputCount else {
            showAlert?("알림", "올바른 숫자를 입력해주세요")
            return
        }
        
        guard count <= 49 else {
            showAlert?("알림", "다마고치가 한 번에 먹을 수 있는 물의 양은 49개까지입니다")
            return
        }
        
        model.waterCount += count
        clearTextField?(.water)
        updateTamagochiLevel()
        saveTamagochiData()
        updateWaterMessage(inputCount: count)
    }
}

private extension TamaMainViewModel {
    
    func parseInput(_ input: String, defaultValue: Int) -> Int? {
        let trimmedInput = input.trimmingCharacters(in: .whitespaces)
        
        if trimmedInput.isEmpty {
            return defaultValue
        }
        
        guard let count = Int(trimmedInput), count > 0 else {
            return nil
        }
        
        return count
    }
    
    func updateTamagochiLevel() {
        let calculatedLevel = model.calculatedLevel
        
        if calculatedLevel != model.level {
            let oldLevel = model.level
            model.level = calculatedLevel
            updateLevelUpMessage(oldLevel: oldLevel, newLevel: calculatedLevel)
        }
        
        notifyModelUpdate()
    }
    
    func updateLevelUpMessage(oldLevel: Int, newLevel: Int) {
        let message: String
        
        if newLevel == 10 {
            message = "\(model.ownerName)님 덕분에 최고 레벨에 도달했어요!"
        } else {
            let messages = [
                "\(model.ownerName)님! 레벨 \(newLevel)이 되었어요!",
                "와! \(model.ownerName)님, 레벨업했어요!",
                "\(model.ownerName)님 덕분에 더 강해졌어요!",
                "고마워요 \(model.ownerName)님! 레벨 \(newLevel)이에요!",
                "\(model.ownerName)님과 함께 성장하고 있어요!"
            ]
            message = messages.randomElement() ?? ""
        }
        
        bubbleMessage?(message)
    }
    
    func updateFeedMessage(inputCount: Int) {
        let messages = [
            "\(model.ownerName)님, 밥 \(inputCount)개 잘 먹었어요!",
            "맛있어요! 고마워요 \(model.ownerName)님!",
            "\(model.ownerName)님이 주신 밥이 최고예요!",
            "냠냠! \(model.ownerName)님 사랑해요!",
            "\(model.ownerName)님, 더 달라고 해도 될까요?",
            "배가 부르네요, \(model.ownerName)님!"
        ]
        
        bubbleMessage?(messages.randomElement() ?? "")
    }
    
    func updateWaterMessage(inputCount: Int) {
        let messages = [
            "\(model.ownerName)님, 물 \(inputCount)개 시원해요!",
            "목이 축축해졌어요! 고마워요 \(model.ownerName)님!",
            "\(model.ownerName)님이 주신 물이 달콤해요!",
            "꿀꺽! \(model.ownerName)님 최고예요!",
            "\(model.ownerName)님, 물이 정말 시원해요!",
            "갈증이 해결됐어요, \(model.ownerName)님!"
        ]
        
        bubbleMessage?(messages.randomElement() ?? "")
    }
    
    func updateRandomMessage() {
        let currentHour = Calendar.current.component(.hour, from: Date())
        var timeBasedMessages: [String] = []
        
        // 시간대별 인사말
        if currentHour >= 6 && currentHour < 12 {
            timeBasedMessages = [
                "좋은 아침이에요, \(model.ownerName)님!",
                "\(model.ownerName)님, 오늘도 화이팅!",
                "아침에 만나서 기뻐요, \(model.ownerName)님!"
            ]
        } else if currentHour >= 12 && currentHour < 18 {
            timeBasedMessages = [
                "좋은 오후예요, \(model.ownerName)님!",
                "\(model.ownerName)님, 점심은 드셨나요?",
                "오후에도 힘내세요, \(model.ownerName)님!"
            ]
        } else if currentHour >= 18 && currentHour < 22 {
            timeBasedMessages = [
                "좋은 저녁이에요, \(model.ownerName)님!",
                "\(model.ownerName)님, 오늘 하루 수고하셨어요!",
                "저녁 시간이네요, \(model.ownerName)님!"
            ]
        } else {
            timeBasedMessages = [
                "늦은 시간이네요, \(model.ownerName)님!",
                "\(model.ownerName)님, 오늘도 고생하셨어요!",
                "밤늦게까지 고마워요, \(model.ownerName)님!"
            ]
        }
        
        // 일반 메시지와 시간별 메시지 조합
        let generalMessages = [
            "\(model.ownerName)님, 저를 키워주세요!",
            "안녕하세요 \(model.ownerName)님!",
            "\(model.ownerName)님과 함께해서 행복해요!",
            "\(model.ownerName)님, 오늘도 잘 부탁드려요!",
            "레벨 \(model.level)이에요, \(model.ownerName)님!",
            "\(model.ownerName)님, 밥과 물을 주세요!"
        ]
        
        let allMessages = timeBasedMessages + generalMessages
        bubbleMessage?(allMessages.randomElement() ?? "")
    }
    
    func loadTamagochiData() {
        model.level = userDefaults.loadTamagochiLevel()
        model.riceCount = userDefaults.loadRiceCount()
        model.waterCount = userDefaults.loadWaterCount()
        
        let savedType = userDefaults.loadSelectedTamagochiType()
        model.selectedType = String(savedType.prefix(1))
        
        model.ownerName = userDefaults.loadTamagochiName()
        
        notifyModelUpdate()
    }
    
    func loadOwnerName() {
        model.ownerName = userDefaults.loadTamagochiName()
        notifyModelUpdate()
    }
    
    func loadTamagochiType() {
        let savedType = userDefaults.loadSelectedTamagochiType()
        model.selectedType = String(savedType.prefix(1))
        notifyModelUpdate()
    }
    
    func saveTamagochiData() {
        userDefaults.saveTamagochiData(
            level: model.level,
            riceCount: model.riceCount,
            waterCount: model.waterCount
        )
    }
    
    func notifyModelUpdate() {
        tamagochiModel?(model)
    }
}
