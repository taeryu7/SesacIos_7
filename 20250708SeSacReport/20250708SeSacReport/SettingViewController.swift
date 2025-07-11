//
//  SettingViewController.swift
//  20250708SeSacReport
//
//  Created by 유태호 on 7/8/25.
//

import UIKit

class SettingViewController: UIViewController {

    
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(UserDefaults.standard.string(forKey: "name"))
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              name.count >= 2,
              name.count <= 6 else {
            
            let alert = UIAlertController(title: "알림", message: "이름은 2글자 이상 6글자 이하로 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        UserDefaults.standard.set(name, forKey: "name")
    }
    
    @IBAction func nameTextField(_ sender: UITextField) {
        view.endEditing(true)
    }
    

}
