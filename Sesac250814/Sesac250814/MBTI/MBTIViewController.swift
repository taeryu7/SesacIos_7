//
//  MBTIViewController.swift
//  SesacWeek7
//
//  Created by 유태호 on 8/9/25.
//

import UIKit
import SnapKit

class MBTIViewController: UIViewController {
    
    private let viewModel = MBTIViewModel()
    
    let profileImageView = UIImageView()
    let nicknameTextField = UITextField()
    let nicknameUnderlineView = UIView()
    let validationLabel = UILabel()
    let mbtiLabel = UILabel()
    var mbtiButtons: [[UIButton]] = []
    let completeButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureUI()
        configureLayout()
        setupActions()
        setupObservables()
        setupInitialState()
    }
    
    func configureHierarchy() {
        view.addSubview(profileImageView)
        view.addSubview(nicknameTextField)
        view.addSubview(nicknameUnderlineView)
        view.addSubview(validationLabel)
        view.addSubview(mbtiLabel)
        view.addSubview(completeButton)
    }
    
    func configureUI() {
        view.backgroundColor = .white
        title = "PROFILE SETTING"
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 40
        profileImageView.layer.masksToBounds = true
        profileImageView.backgroundColor = .systemGray5
        profileImageView.isUserInteractionEnabled = true
        
        nicknameTextField.placeholder = "닉네임을 입력해주세요"
        nicknameTextField.borderStyle = .none
        nicknameTextField.textAlignment = .center
        nicknameTextField.font = .systemFont(ofSize: 16)
        
        nicknameUnderlineView.backgroundColor = .systemGray4
        
        validationLabel.text = ""
        validationLabel.textAlignment = .center
        validationLabel.font = .systemFont(ofSize: 13)
        validationLabel.isHidden = true
        
        mbtiLabel.text = "MBTI"
        mbtiLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        setupMBTIButtons()
        
        completeButton.setTitle("완료", for: .normal)
        completeButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        completeButton.backgroundColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1)
        completeButton.setTitleColor(.white, for: .normal)
        completeButton.layer.cornerRadius = 25
        completeButton.isEnabled = false
    }
    
    func setupMBTIButtons() {
        let allOptions: [MBTIOption] = [.E, .S, .T, .J, .I, .N, .F, .P]
        
        for (index, option) in allOptions.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(option.rawValue, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            button.layer.cornerRadius = 20
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemGray4.cgColor
            button.backgroundColor = .clear
            button.setTitleColor(.black, for: .normal)
            
            button.tag = index
            button.addTarget(self, action: #selector(mbtiButtonTapped(_:)), for: .touchUpInside)
            
            view.addSubview(button)
            
            let row = index / 4
            let col = index % 4
            
            if mbtiButtons.count <= row {
                mbtiButtons.append([])
            }
            mbtiButtons[row].append(button)
        }
    }
    
    func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalTo(view)
            make.width.height.equalTo(80)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(30)
            make.leading.trailing.equalTo(view).inset(50)
            make.height.equalTo(40)
        }
        
        nicknameUnderlineView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom)
            make.leading.trailing.equalTo(nicknameTextField)
            make.height.equalTo(1)
        }
        
        validationLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameUnderlineView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(nicknameTextField)
            make.height.equalTo(20)
        }
        
        mbtiLabel.snp.makeConstraints { make in
            make.top.equalTo(validationLabel.snp.bottom).offset(40)
            make.leading.equalTo(view).offset(20)
        }
        
        setupMBTIButtonConstraints()
        
        completeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.leading.trailing.equalTo(view).inset(20)
            make.height.equalTo(50)
        }
    }
    
    func setupMBTIButtonConstraints() {
        // 첫번째줄 : ESTJ
        for (index, button) in mbtiButtons[0].enumerated() {
            button.snp.makeConstraints { make in
                make.centerY.equalTo(mbtiLabel)
                
                if index == 0 {
                    make.leading.equalTo(mbtiLabel.snp.trailing).offset(20)
                } else {
                    make.leading.equalTo(mbtiButtons[0][index - 1].snp.trailing).offset(15)
                }
                
                make.width.equalTo(50)
                make.height.equalTo(40)
            }
        }
        
        // 두번째줄 : INFP
        for (index, button) in mbtiButtons[1].enumerated() {
            button.snp.makeConstraints { make in
                make.top.equalTo(mbtiButtons[0][0].snp.bottom).offset(15)
                make.leading.equalTo(mbtiButtons[0][index].snp.leading)
                make.width.equalTo(50)
                make.height.equalTo(40)
            }
        }
    }
    
    func setupActions() {
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(profileTapGesture)
        
        nicknameTextField.addTarget(self, action: #selector(nicknameTextChanged), for: .editingChanged)
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    func setupObservables() {
        viewModel.profileImageIndex.playAction(owner: self) { [weak self] in
            DispatchQueue.main.async {
                if let imageIndex = Int(self?.viewModel.profileImageIndex.text ?? "0") {
                    self?.updateProfileImage(imageIndex)
                }
            }
        }
        
        viewModel.validationMessage.playAction(owner: self) { [weak self] in
            DispatchQueue.main.async {
                self?.validationLabel.text = self?.viewModel.validationMessage.text
            }
        }
        
        viewModel.validationColor.playAction(owner: self) { [weak self] in
            DispatchQueue.main.async {
                let colorText = self?.viewModel.validationColor.text ?? "red"
                if colorText == "blue" {
                    self?.validationLabel.textColor = UIColor(red: 24/255, green: 111/255, blue: 242/255, alpha: 1)
                } else {
                    self?.validationLabel.textColor = UIColor(red: 240/255, green: 68/255, blue: 82/255, alpha: 1)
                }
            }
        }
        
        viewModel.validationHidden.playAction(owner: self) { [weak self] in
            DispatchQueue.main.async {
                let isHidden = self?.viewModel.validationHidden.text == "true"
                self?.validationLabel.isHidden = isHidden
            }
        }
        
        viewModel.completeButtonEnabled.playAction(owner: self) { [weak self] in
            DispatchQueue.main.async {
                let isEnabled = self?.viewModel.completeButtonEnabled.text == "true"
                self?.updateCompleteButton(isEnabled)
            }
        }
        
        viewModel.mbtiState.playAction(owner: self) { [weak self] in
            DispatchQueue.main.async {
                self?.updateMBTIButtons()
            }
        }
        
        viewModel.showSuccessAlert.playAction(owner: self) { [weak self] in
            DispatchQueue.main.async {
                if self?.viewModel.showSuccessAlert.text == "true" {
                    self?.showCompletionAlert()
                    self?.viewModel.showSuccessAlert.text = "false"
                }
            }
        }
   }

     func setupInitialState() {
        updateProfileImage(viewModel.getCurrentProfileImageIndex())
        updateMBTIButtons()
    }
    
    func updateProfileImage(_ imageIndex: Int) {
        let imageName = "char\(imageIndex + 1)"
        profileImageView.image = UIImage(named: imageName) ?? UIImage(systemName: "person.circle.fill")
    }
    
    func updateMBTIButtons() {
        let allOptions: [MBTIOption] = [.E, .S, .T, .J, .I, .N, .F, .P]
        
        for (index, option) in allOptions.enumerated() {
            let row = index / 4
            let col = index % 4
            let button = mbtiButtons[row][col]
            
            var category: MBTICategory
            switch option {
            case .E, .I:
                category = .E_I
            case .S, .N:
                category = .S_N
            case .T, .F:
                category = .T_F
            case .J, .P:
                category = .J_P
            }
            
            let isSelected = viewModel.isOptionSelected(category: category, option: option)
            
            if isSelected {
                button.backgroundColor = UIColor(red: 24/255, green: 111/255, blue: 242/255, alpha: 1)
                button.setTitleColor(.white, for: .normal)
                button.layer.borderColor = UIColor(red: 24/255, green: 111/255, blue: 242/255, alpha: 1).cgColor
            } else {
                button.backgroundColor = .clear
                button.setTitleColor(.black, for: .normal)
                button.layer.borderColor = UIColor.systemGray4.cgColor
            }
        }
    }
    
    func updateCompleteButton(_ isEnabled: Bool) {
        completeButton.isEnabled = isEnabled
        
        if isEnabled {
            completeButton.backgroundColor = UIColor(red: 24/255, green: 111/255, blue: 242/255, alpha: 1)
        } else {
            completeButton.backgroundColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1)
        }
    }
    
    func showCompletionAlert() {
        let alert = UIAlertController(title: "프로필 설정 완료", message: "프로필이 성공적으로 설정되었습니다!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    @objc func profileImageTapped() {
        let currentIndex = viewModel.getCurrentProfileImageIndex()
        let profileVC = MBTIProfileViewController(currentImageIndex: currentIndex)
        profileVC.delegate = self
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc func nicknameTextChanged() {
        viewModel.updateNickname(nicknameTextField.text ?? "")
    }
    
    @objc func mbtiButtonTapped(_ sender: UIButton) {
        let allOptions: [MBTIOption] = [.E, .S, .T, .J, .I, .N, .F, .P]
        let selectedOption = allOptions[sender.tag]
        
        var category: MBTICategory
        switch selectedOption {
        case .E, .I:
            category = .E_I
        case .S, .N:
            category = .S_N
        case .T, .F:
            category = .T_F
        case .J, .P:
            category = .J_P
        }
        
        viewModel.selectMBTI(category: category, option: selectedOption)
    }
    
    @objc func completeButtonTapped() {
        viewModel.completeButtonTapped()
        
        // 프로필 이미지 인덱스 저장
        let currentImageIndex = viewModel.getCurrentProfileImageIndex()
        UserDefaults.standard.set(currentImageIndex, forKey: "selectedProfileImageIndex")
        
        // 닉네임 저장
        let currentNickname = nicknameTextField.text ?? ""
        UserDefaults.standard.set(currentNickname, forKey: "savedNickname")
        
        // MBTI 정보 저장
        let currentMBTI = viewModel.getCurrentMBTI()
        if let ei = currentMBTI.E_I {
            UserDefaults.standard.set(ei.rawValue, forKey: "savedMBTI_EI")
        }
        if let sn = currentMBTI.S_N {
            UserDefaults.standard.set(sn.rawValue, forKey: "savedMBTI_SN")
        }
        if let tf = currentMBTI.T_F {
            UserDefaults.standard.set(tf.rawValue, forKey: "savedMBTI_TF")
        }
        if let jp = currentMBTI.J_P {
            UserDefaults.standard.set(jp.rawValue, forKey: "savedMBTI_JP")
        }
        
        print("프로필 저장 완료 - 이미지: \(currentImageIndex), 닉네임: \(currentNickname), MBTI: \(currentMBTI.displayText)")
    }
    
    @objc func backButtonTapped() {
        // 뒤로가기할 때도 현재 설정된 프로필 이미지 저장
        let currentImageIndex = viewModel.getCurrentProfileImageIndex()
        UserDefaults.standard.set(currentImageIndex, forKey: "selectedProfileImageIndex")
        navigationController?.popViewController(animated: true)
    }
}

extension MBTIViewController: MBTIProfileDelegate {
    func didSelectProfileImage(index: Int) {
        viewModel.updateProfileImage(index)
    }
}
