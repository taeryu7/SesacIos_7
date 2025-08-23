//
//  TamaMainViewController.swift
//  20250708SeSacReport
//
//  Created by 유태호 on 7/9/25.
//

import UIKit
import SnapKit

class TamaMainViewController: UIViewController {
    
    // UI 요소들
    let navigationSeparatorLine = UIView()
    let bubbleImageView = UIImageView()
    let bubbleLabel = UILabel()
    let tamagochiImageView = UIImageView()
    let nameLabel = UILabel()
    let statusLabel = UILabel()
    let feedTextField = UITextField()
    let feedSeparatorLine = UIView()
    let feedButton = UIButton()
    let waterTextField = UITextField()
    let waterSeparatorLine = UIView()
    let waterButton = UIButton()
    
    // 다마고치 상태
    var currentLevel = 1
    var riceCount = 0
    var waterCount = 0
    var selectedTamagochiType = "1" // 1, 2, 3 중 하나
    var ownerName = "대장" // 대장 이름

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        configureHierarchy()
        configureUView()
        configureLayout()
        setupNavigationBar()
        loadTamagochiData()
        updateRandomMessage() // 화면 진입 시 랜덤 메시지
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        
        // 이름 다시 로드
        ownerName = TamagochiUserDefaults.shared.loadTamagochiName()
        
        // 다마고치 타입 다시 로드
        let savedType = TamagochiUserDefaults.shared.loadSelectedTamagochiType()
        selectedTamagochiType = String(savedType.prefix(1))
        
        updateNavigationTitle()
        updateTamagochiImage() // 다마고치 이미지 업데이트
        updateRandomMessage() // 화면 재진입 시 새로운 메시지
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
    }
    
    @objc private func feedButtonTapped() {
        let inputText = feedTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        var inputCount = 1 // 텍스트필드가 비어있으면 기본값 1
        
        // 텍스트필드에 값이 있으면 해당 값 사용
        if !inputText.isEmpty {
            guard let count = Int(inputText), count > 0 else {
                showAlert(title: "알림", message: "올바른 숫자를 입력해주세요")
                return
            }
            inputCount = count
        }
        
        // 밥알 최대 99개 제한
        if inputCount > 99 {
            showAlert(title: "알림", message: "다마고치가 한 번에 먹을 수 있는 밥의 양은 99개까지입니다")
            return
        }
        
        print("밥먹기 버튼 탭됨 - 입력값: \(inputCount)")
        riceCount += inputCount
        feedTextField.text = ""
        updateTamagochiLevel()
        saveTamagochiData()
        updateFeedMessage(inputCount: inputCount) // 밥 먹을 때마다 새로운 메시지
    }
    
    @objc private func waterButtonTapped() {
        let inputText = waterTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        var inputCount = 1 // 텍스트필드가 비어있으면 기본값 1
        
        // 텍스트필드에 값이 있으면 해당 값 사용
        if !inputText.isEmpty {
            guard let count = Int(inputText), count > 0 else {
                showAlert(title: "알림", message: "올바른 숫자를 입력해주세요")
                return
            }
            inputCount = count
        }
        
        // 물방울 최대 49개 제한
        if inputCount > 49 {
            showAlert(title: "알림", message: "다마고치가 한 번에 먹을 수 있는 물의 양은 49개까지입니다")
            return
        }
        
        print("물먹기 버튼 탭됨 - 입력값: \(inputCount)")
        waterCount += inputCount
        waterTextField.text = ""
        updateTamagochiLevel()
        saveTamagochiData()
        updateWaterMessage(inputCount: inputCount) // 물 먹을 때마다 새로운 메시지
    }
    
    private func updateTamagochiLevel() {
        let calculatedLevel = Int((Double(riceCount) / 5.0) + (Double(waterCount) / 2.0))
        
        let newLevel = max(1, min(10, calculatedLevel))
        
        if newLevel != currentLevel {
            let oldLevel = currentLevel
            currentLevel = newLevel
            updateTamagochiImage()
            updateLevelUpMessage(oldLevel: oldLevel, newLevel: newLevel)
        }
        
        updateStatusLabel()
    }
    
    private func updateLevelUpMessage(oldLevel: Int, newLevel: Int) {
        if newLevel == 10 {
            bubbleLabel.text = "\(ownerName)님 덕분에 최고 레벨에 도달했어요!"
        } else {
            let messages = [
                "\(ownerName)님! 레벨 \(newLevel)이 되었어요!",
                "와! \(ownerName)님, 레벨업했어요!",
                "\(ownerName)님 덕분에 더 강해졌어요!",
                "고마워요 \(ownerName)님! 레벨 \(newLevel)이에요!",
                "\(ownerName)님과 함께 성장하고 있어요!"
            ]
            bubbleLabel.text = messages.randomElement()
        }
    }
    
    // 밥 먹을 때 메시지
    private func updateFeedMessage(inputCount: Int) {
        let messages = [
            "\(ownerName)님, 밥 \(inputCount)개 잘 먹었어요!",
            "맛있어요! 고마워요 \(ownerName)님!",
            "\(ownerName)님이 주신 밥이 최고예요!",
            "냠냠! \(ownerName)님 사랑해요!",
            "\(ownerName)님, 더 달라고 해도 될까요?",
            "배가 부르네요, \(ownerName)님!"
        ]
        bubbleLabel.text = messages.randomElement()
    }
    
    // 물 먹을 때 메시지
    private func updateWaterMessage(inputCount: Int) {
        let messages = [
            "\(ownerName)님, 물 \(inputCount)개 시원해요!",
            "목이 축축해졌어요! 고마워요 \(ownerName)님!",
            "\(ownerName)님이 주신 물이 달콤해요!",
            "꿀꺽! \(ownerName)님 최고예요!",
            "\(ownerName)님, 물이 정말 시원해요!",
            "갈증이 해결됐어요, \(ownerName)님!"
        ]
        bubbleLabel.text = messages.randomElement()
    }
    
    // 화면 진입 시 랜덤 메시지
    private func updateRandomMessage() {
        let currentHour = Calendar.current.component(.hour, from: Date())
        var timeBasedMessages: [String] = []
        
        // 시간대별 인사말
        if currentHour >= 6 && currentHour < 12 {
            timeBasedMessages = [
                "좋은 아침이에요, \(ownerName)님!",
                "\(ownerName)님, 오늘도 화이팅!",
                "아침에 만나서 기뻐요, \(ownerName)님!"
            ]
        } else if currentHour >= 12 && currentHour < 18 {
            timeBasedMessages = [
                "좋은 오후예요, \(ownerName)님!",
                "\(ownerName)님, 점심은 드셨나요?",
                "오후에도 힘내세요, \(ownerName)님!"
            ]
        } else if currentHour >= 18 && currentHour < 22 {
            timeBasedMessages = [
                "좋은 저녁이에요, \(ownerName)님!",
                "\(ownerName)님, 오늘 하루 수고하셨어요!",
                "저녁 시간이네요, \(ownerName)님!"
            ]
        } else {
            timeBasedMessages = [
                "늦은 시간이네요, \(ownerName)님!",
                "\(ownerName)님, 오늘도 고생하셨어요!",
                "밤늦게까지 고마워요, \(ownerName)님!"
            ]
        }
        
        // 일반 메시지와 시간별 메시지 조합
        let generalMessages = [
            "\(ownerName)님, 저를 키워주세요!",
            "안녕하세요 \(ownerName)님!",
            "\(ownerName)님과 함께해서 행복해요!",
            "\(ownerName)님, 오늘도 잘 부탁드려요!",
            "레벨 \(currentLevel)이에요, \(ownerName)님!",
            "\(ownerName)님, 밥과 물을 주세요!"
        ]
        
        let allMessages = timeBasedMessages + generalMessages
        bubbleLabel.text = allMessages.randomElement()
    }
    
    private func updateNavigationTitle() {
        navigationItem.title = "\(ownerName)님의 다마고치"
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    @objc func unwindToTamaMain() {
        print("tamaMainViewController로 백")
    }
}

extension TamaMainViewController {
    
    func configureHierarchy() {
        view.addSubview(navigationSeparatorLine)
        view.addSubview(bubbleImageView)
        view.addSubview(bubbleLabel)
        view.addSubview(tamagochiImageView)
        view.addSubview(nameLabel)
        view.addSubview(statusLabel)
        view.addSubview(feedTextField)
        view.addSubview(feedSeparatorLine)
        view.addSubview(feedButton)
        view.addSubview(waterTextField)
        view.addSubview(waterSeparatorLine)
        view.addSubview(waterButton)
    }
    
    func configureUView() {
        // 네비게이션 구분선
        navigationSeparatorLine.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        // 말풍선 이미지뷰
        bubbleImageView.snp.makeConstraints { make in
            make.top.equalTo(navigationSeparatorLine.snp.bottom).offset(30)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
            make.height.equalTo(100)
        }
        
        // 말풍선 텍스트
        bubbleLabel.snp.makeConstraints { make in
            make.center.equalTo(bubbleImageView)
            make.width.equalTo(bubbleImageView).offset(-40)
        }
        
        // 다마고치 이미지
        tamagochiImageView.snp.makeConstraints { make in
            make.top.equalTo(bubbleImageView.snp.bottom).offset(30)
            make.centerX.equalTo(view)
            make.width.height.equalTo(200)
        }
        
        // 이름 라벨 (테두리 추가)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(tamagochiImageView.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.height.equalTo(40)
        }
        
        // 상태 라벨 (레벨 · 밥알 · 물방울)
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.centerX.equalTo(view)
        }
        
        // 밥 텍스트필드
        feedTextField.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(30)
            make.centerX.equalTo(tamagochiImageView)
            make.leading.equalTo(tamagochiImageView.snp.leading)
            make.trailing.equalTo(feedButton.snp.leading).offset(-10)
            make.height.equalTo(40)
        }
        
        // 밥 구분선
        feedSeparatorLine.snp.makeConstraints { make in
            make.top.equalTo(feedTextField.snp.bottom)
            make.leading.trailing.equalTo(feedTextField)
            make.height.equalTo(1)
        }
        
        // 밥먹기 버튼
        feedButton.snp.makeConstraints { make in
            make.centerY.equalTo(feedTextField)
            make.trailing.equalTo(tamagochiImageView.snp.trailing)
            make.width.equalTo(70)
            make.height.equalTo(40)
        }
        
        // 물 텍스트필드
        waterTextField.snp.makeConstraints { make in
            make.top.equalTo(feedSeparatorLine.snp.bottom).offset(20)
            make.centerX.equalTo(tamagochiImageView)
            make.leading.equalTo(tamagochiImageView.snp.leading)
            make.trailing.equalTo(waterButton.snp.leading).offset(-10)
            make.height.equalTo(40)
        }
        
        // 물 구분선
        waterSeparatorLine.snp.makeConstraints { make in
            make.top.equalTo(waterTextField.snp.bottom)
            make.leading.trailing.equalTo(waterTextField)
            make.height.equalTo(1)
        }
        
        // 물먹기 버튼
        waterButton.snp.makeConstraints { make in
            make.centerY.equalTo(waterTextField)
            make.trailing.equalTo(tamagochiImageView.snp.trailing)
            make.width.equalTo(70)
            make.height.equalTo(40)
        }
    }
    
    func configureLayout() {
        view.backgroundColor = .systemBackground
        
        // 네비게이션 구분선
        navigationSeparatorLine.backgroundColor = .systemGray4
        
        // 말풍선
        bubbleImageView.image = UIImage(named: "bubble")
        bubbleImageView.contentMode = .scaleAspectFit
        
        // 말풍선 텍스트
        bubbleLabel.text = "안녕하세요! 저를 키워주세요~"
        bubbleLabel.textAlignment = .center
        bubbleLabel.font = UIFont.systemFont(ofSize: 14)
        bubbleLabel.numberOfLines = 0
        bubbleLabel.textColor = .black
        
        // 다마고치 이미지
        updateTamagochiImage()
        tamagochiImageView.contentMode = .scaleAspectFit
        tamagochiImageView.layer.cornerRadius = 100
        tamagochiImageView.backgroundColor = .systemGray6
        
        // 이름 라벨
        nameLabel.text = "대장 다마고치"
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .black
        nameLabel.layer.borderWidth = 1
        nameLabel.layer.borderColor = UIColor.systemGray4.cgColor
        nameLabel.layer.cornerRadius = 8
        
        // 상태 라벨 (레벨 · 밥알 · 물방울)
        updateStatusLabel()
        statusLabel.font = UIFont.systemFont(ofSize: 14)
        statusLabel.textAlignment = .center
        statusLabel.textColor = .systemGray
        
        // 밥 텍스트필드
        feedTextField.placeholder = "밥주세욤"
        feedTextField.font = UIFont.systemFont(ofSize: 16)
        feedTextField.textColor = .black
        feedTextField.textAlignment = .center
        feedTextField.borderStyle = .none
        feedTextField.keyboardType = .numberPad
        
        // 밥 구분선
        feedSeparatorLine.backgroundColor = .black
        
        // 밥먹기 버튼
        feedButton.setTitle("  밥먹기", for: .normal)
        feedButton.setImage(UIImage(systemName: "fork.knife"), for: .normal)
        feedButton.backgroundColor = .systemOrange
        feedButton.setTitleColor(.white, for: .normal)
        feedButton.tintColor = .white
        feedButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        feedButton.layer.cornerRadius = 8
        feedButton.addTarget(self, action: #selector(feedButtonTapped), for: .touchUpInside)
        
        // 물 텍스트필드
        waterTextField.placeholder = "물주세욤"
        waterTextField.font = UIFont.systemFont(ofSize: 16)
        waterTextField.textColor = .black
        waterTextField.textAlignment = .center
        waterTextField.borderStyle = .none
        waterTextField.keyboardType = .numberPad
        
        // 물 구분선
        waterSeparatorLine.backgroundColor = .black
        
        // 물먹기 버튼
        waterButton.setTitle("  물먹기", for: .normal)
        waterButton.setImage(UIImage(systemName: "drop.fill"), for: .normal)
        waterButton.backgroundColor = .systemBlue
        waterButton.setTitleColor(.white, for: .normal)
        waterButton.tintColor = .white
        waterButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        waterButton.layer.cornerRadius = 8
        waterButton.addTarget(self, action: #selector(waterButtonTapped), for: .touchUpInside)
    }
    
    private func updateStatusLabel() {
        statusLabel.text = "LV.\(currentLevel) · 밥알 \(riceCount)개 · 물방울 \(waterCount)개"
    }
    
    private func updateTamagochiImage() {
        // 레벨 10일 때는 가장 높은 단계(9) 이미지 사용
        let imageStage = min(currentLevel, 9)
        let imageName = "\(selectedTamagochiType)-\(imageStage)"
        tamagochiImageView.image = UIImage(named: imageName) ?? UIImage(named: "noImage")
    }
    
    private func loadTamagochiData() {
        currentLevel = TamagochiUserDefaults.shared.loadTamagochiLevel()
        riceCount = TamagochiUserDefaults.shared.loadRiceCount()
        waterCount = TamagochiUserDefaults.shared.loadWaterCount()
        
        // 선택된 다마고치 타입 로드
        let savedType = TamagochiUserDefaults.shared.loadSelectedTamagochiType()
        selectedTamagochiType = String(savedType.prefix(1)) // 첫 번째 문자만 추출
        
        // 사용자 이름 로드
        ownerName = TamagochiUserDefaults.shared.loadTamagochiName()
        nameLabel.text = ownerName
        
        updateTamagochiImage()
        updateStatusLabel()
        updateNavigationTitle()
    }
    
    private func saveTamagochiData() {
        TamagochiUserDefaults.shared.saveTamagochiData(
            level: currentLevel,
            riceCount: riceCount,
            waterCount: waterCount
        )
    }
    
    
    @objc private func profileButtonTapped() {
        let tamaSubVC = TamaSubViewController()
        navigationController?.pushViewController(tamaSubVC, animated: true)
    }
    
    private func setupNavigationBar() {
        updateNavigationTitle()
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.systemGray
        ]
        
        // 프로필 아이콘 설정
        let profileBarButton = UIBarButtonItem(
            image: UIImage(systemName: "person.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(profileButtonTapped)
        )
        profileBarButton.tintColor = UIColor.systemGray
        navigationItem.rightBarButtonItem = profileBarButton
    }
}

#Preview {
    let navController = UINavigationController(rootViewController: TamaMainViewController())
    return navController
}
