//
//  TamaMainViewModel.swift
//  Sesac20250822
//
//  Created by 유태호 on 8/23/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol TamaMainViewModelInput {
    var feedButtonTap: PublishSubject<String> { get }
    var waterButtonTap: PublishSubject<String> { get }
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var viewWillAppearTrigger: PublishSubject<Void> { get }
}

protocol TamaMainViewModelOutput {
    var tamagochiModel: Driver<TamagochiModel> { get }
    var bubbleMessage: Driver<String> { get }
    var showAlert: Driver<(String, String)> { get }
    var clearTextField: Driver<TextFieldType> { get }
}

enum TextFieldType {
    case feed
    case water
}

final class TamaMainViewModel: TamaMainViewModelInput, TamaMainViewModelOutput {
    
    let feedButtonTap = PublishSubject<String>()
    let waterButtonTap = PublishSubject<String>()
    let viewDidLoadTrigger = PublishSubject<Void>()
    let viewWillAppearTrigger = PublishSubject<Void>()
    
    let tamagochiModel: Driver<TamagochiModel>
    let bubbleMessage: Driver<String>
    let showAlert: Driver<(String, String)>
    let clearTextField: Driver<TextFieldType>
    
    private let tamagochiModelSubject = BehaviorSubject<TamagochiModel>(value: TamagochiModel())
    private let bubbleMessageSubject = PublishSubject<String>()
    private let showAlertSubject = PublishSubject<(String, String)>()
    private let clearTextFieldSubject = PublishSubject<TextFieldType>()
    private let userDefaults = TamagochiUserDefaults.shared
    private let disposeBag = DisposeBag()
    
    init() {
        // Output 설정
        self.tamagochiModel = tamagochiModelSubject.asDriver(onErrorJustReturn: TamagochiModel())
        self.bubbleMessage = bubbleMessageSubject.asDriver(onErrorJustReturn: "")
        self.showAlert = showAlertSubject.asDriver(onErrorJustReturn: ("", ""))
        self.clearTextField = clearTextFieldSubject.asDriver(onErrorJustReturn: .feed)
        
        // Input 바인딩
        setupBindings()
    }
    
    private func setupBindings() {
        // viewDidLoad 처리
        viewDidLoadTrigger
            .subscribe(onNext: { [weak self] in
                self?.loadTamagochiData()
                self?.updateRandomMessage()
            })
            .disposed(by: disposeBag)
        
        // viewWillAppear 처리
        viewWillAppearTrigger
            .subscribe(onNext: { [weak self] in
                self?.loadOwnerName()
                self?.loadTamagochiType()
                self?.updateRandomMessage()
            })
            .disposed(by: disposeBag)
        
        // 밥 버튼 탭 처리
        feedButtonTap
            .subscribe(onNext: { [weak self] inputText in
                self?.handleFeedButton(inputText: inputText)
            })
            .disposed(by: disposeBag)
        
        // 물 버튼 탭 처리
        waterButtonTap
            .subscribe(onNext: { [weak self] inputText in
                self?.handleWaterButton(inputText: inputText)
            })
            .disposed(by: disposeBag)
    }
    
    private func handleFeedButton(inputText: String) {
        let inputCount = parseInput(inputText, defaultValue: 1)
        
        guard let count = inputCount else {
            showAlertSubject.onNext(("알림", "올바른 숫자를 입력해주세요"))
            return
        }
        
        guard count <= 99 else {
            showAlertSubject.onNext(("알림", "다마고치가 한 번에 먹을 수 있는 밥의 양은 99개까지입니다"))
            return
        }
        
        var currentModel = try! tamagochiModelSubject.value()
        currentModel.riceCount += count
        clearTextFieldSubject.onNext(.feed)
        updateTamagochiLevel(model: &currentModel)
        saveTamagochiData(model: currentModel)
        updateFeedMessage(inputCount: count, ownerName: currentModel.ownerName)
        
        tamagochiModelSubject.onNext(currentModel)
    }
    
    private func handleWaterButton(inputText: String) {
        let inputCount = parseInput(inputText, defaultValue: 1)
        
        guard let count = inputCount else {
            showAlertSubject.onNext(("알림", "올바른 숫자를 입력해주세요"))
            return
        }
        
        guard count <= 49 else {
            showAlertSubject.onNext(("알림", "다마고치가 한 번에 먹을 수 있는 물의 양은 49개까지입니다"))
            return
        }
        
        var currentModel = try! tamagochiModelSubject.value()
        currentModel.waterCount += count
        clearTextFieldSubject.onNext(.water)
        updateTamagochiLevel(model: &currentModel)
        saveTamagochiData(model: currentModel)
        updateWaterMessage(inputCount: count, ownerName: currentModel.ownerName)
        
        tamagochiModelSubject.onNext(currentModel)
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
    
    func updateTamagochiLevel(model: inout TamagochiModel) {
        let calculatedLevel = model.calculatedLevel
        
        if calculatedLevel != model.level {
            let oldLevel = model.level
            model.level = calculatedLevel
            updateLevelUpMessage(oldLevel: oldLevel, newLevel: calculatedLevel, ownerName: model.ownerName)
        }
    }
    
    func updateLevelUpMessage(oldLevel: Int, newLevel: Int, ownerName: String) {
        let message: String
        
        if newLevel == 10 {
            message = "\(ownerName)님 덕분에 최고 레벨에 도달했어요!"
        } else {
            let messages = [
                "\(ownerName)님! 레벨 \(newLevel)이 되었어요!",
                "와! \(ownerName)님, 레벨업했어요!",
                "\(ownerName)님 덕분에 더 강해졌어요!",
                "고마워요 \(ownerName)님! 레벨 \(newLevel)이에요!",
                "\(ownerName)님과 함께 성장하고 있어요!"
            ]
            message = messages.randomElement() ?? ""
        }
        
        bubbleMessageSubject.onNext(message)
    }
    
    func updateFeedMessage(inputCount: Int, ownerName: String) {
        let messages = [
            "\(ownerName)님, 밥 \(inputCount)개 잘 먹었어요!",
            "맛있어요! 고마워요 \(ownerName)님!",
            "\(ownerName)님이 주신 밥이 최고예요!",
            "냠냠! \(ownerName)님 사랑해요!",
            "\(ownerName)님, 더 달라고 해도 될까요?",
            "배가 부르네요, \(ownerName)님!"
        ]
        
        bubbleMessageSubject.onNext(messages.randomElement() ?? "")
    }
    
    func updateWaterMessage(inputCount: Int, ownerName: String) {
        let messages = [
            "\(ownerName)님, 물 \(inputCount)개 시원해요!",
            "목이 축축해졌어요! 고마워요 \(ownerName)님!",
            "\(ownerName)님이 주신 물이 달콤해요!",
            "꿀꺽! \(ownerName)님 최고예요!",
            "\(ownerName)님, 물이 정말 시원해요!",
            "갈증이 해결됐어요, \(ownerName)님!"
        ]
        
        bubbleMessageSubject.onNext(messages.randomElement() ?? "")
    }
    
    func updateRandomMessage() {
        let currentModel = try! tamagochiModelSubject.value()
        let currentHour = Calendar.current.component(.hour, from: Date())
        var timeBasedMessages: [String] = []
        
        // 시간대별 인사말
        if currentHour >= 6 && currentHour < 12 {
            timeBasedMessages = [
                "좋은 아침이에요, \(currentModel.ownerName)님!",
                "\(currentModel.ownerName)님, 오늘도 화이팅!",
                "아침에 만나서 기뻐요, \(currentModel.ownerName)님!"
            ]
        } else if currentHour >= 12 && currentHour < 18 {
            timeBasedMessages = [
                "좋은 오후예요, \(currentModel.ownerName)님!",
                "\(currentModel.ownerName)님, 점심은 드셨나요?",
                "오후에도 힘내세요, \(currentModel.ownerName)님!"
            ]
        } else if currentHour >= 18 && currentHour < 22 {
            timeBasedMessages = [
                "좋은 저녁이에요, \(currentModel.ownerName)님!",
                "\(currentModel.ownerName)님, 오늘 하루 수고하셨어요!",
                "저녁 시간이네요, \(currentModel.ownerName)님!"
            ]
        } else {
            timeBasedMessages = [
                "늦은 시간이네요, \(currentModel.ownerName)님!",
                "\(currentModel.ownerName)님, 오늘도 고생하셨어요!",
                "밤늦게까지 고마워요, \(currentModel.ownerName)님!"
            ]
        }
        
        // 일반 메시지와 시간별 메시지 조합
        let generalMessages = [
            "\(currentModel.ownerName)님, 저를 키워주세요!",
            "안녕하세요 \(currentModel.ownerName)님!",
            "\(currentModel.ownerName)님과 함께해서 행복해요!",
            "\(currentModel.ownerName)님, 오늘도 잘 부탁드려요!",
            "레벨 \(currentModel.level)이에요, \(currentModel.ownerName)님!",
            "\(currentModel.ownerName)님, 밥과 물을 주세요!"
        ]
        
        let allMessages = timeBasedMessages + generalMessages
        bubbleMessageSubject.onNext(allMessages.randomElement() ?? "")
    }
    
    func loadTamagochiData() {
        var model = try! tamagochiModelSubject.value()
        model.level = userDefaults.loadTamagochiLevel()
        model.riceCount = userDefaults.loadRiceCount()
        model.waterCount = userDefaults.loadWaterCount()
        
        let savedType = userDefaults.loadSelectedTamagochiType()
        model.selectedType = String(savedType.prefix(1))
        
        model.ownerName = userDefaults.loadTamagochiName()
        
        tamagochiModelSubject.onNext(model)
    }
    
    func loadOwnerName() {
        var model = try! tamagochiModelSubject.value()
        model.ownerName = userDefaults.loadTamagochiName()
        tamagochiModelSubject.onNext(model)
    }
    
    func loadTamagochiType() {
        var model = try! tamagochiModelSubject.value()
        let savedType = userDefaults.loadSelectedTamagochiType()
        model.selectedType = String(savedType.prefix(1))
        tamagochiModelSubject.onNext(model)
    }
    
    func saveTamagochiData(model: TamagochiModel) {
        userDefaults.saveTamagochiData(
            level: model.level,
            riceCount: model.riceCount,
            waterCount: model.waterCount
        )
    }
}
