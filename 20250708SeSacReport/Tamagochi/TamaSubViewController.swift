//
//  TamaSubViewController.swift
//  20250708SeSacReport
//
//  Created by 유태호 on 7/9/25.
//

import UIKit

class TamaSubViewController: UIViewController {

    
    @IBOutlet var nickNameTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickNameTextField.backgroundColor = .red
        nickNameTextField.textColor = .white
        nickNameTextField.placeholder = "닉네임을 입력하세요"
        nickNameTextField.tintColor = .orange
        
    }
    
    @IBAction func saveButtonClicked(_ sender: UIBarButtonItem) {
        print(#function)
    }
    
}
