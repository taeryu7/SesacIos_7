//
//  TamaSubViewController.swift
//  20250708SeSacReport
//
//  Created by 유태호 on 7/9/25.
//

import UIKit
import SnapKit

class TamaSubViewController: UIViewController {
    
    let nickNameTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureUView()
        configureLayout()
        setupNavigationBar()
    }
    
    @objc private func saveButtonClicked() {
        print(#function)
        navigationController?.popViewController(animated: true)
    }
}

extension TamaSubViewController {
    
    func configureHierarchy() {
        view.addSubview(nickNameTextField)
    }
    
    func configureUView() {
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(44)
        }
    }
    
    func configureLayout() {
        view.backgroundColor = .systemBackground
        
        // 텍스트필드 설정
        nickNameTextField.backgroundColor = UIColor(red: 1, green: 0.28367542690000003, blue: 0.0, alpha: 1)
        nickNameTextField.textColor = .white
        nickNameTextField.placeholder = "닉네임을 입력하세요"
        nickNameTextField.tintColor = .orange
        nickNameTextField.borderStyle = .roundedRect
        nickNameTextField.font = UIFont.systemFont(ofSize: 14)
    }
    
    private func setupNavigationBar() {
        // 저장 버튼 설정
        let saveBarButton = UIBarButtonItem(
            title: "저장",
            style: .plain,
            target: self,
            action: #selector(saveButtonClicked)
        )
        navigationItem.rightBarButtonItem = saveBarButton
    }
}

#Preview {
    let navController = UINavigationController(rootViewController: TamaSubViewController())
    return navController
}
