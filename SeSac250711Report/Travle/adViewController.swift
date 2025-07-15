//
//  adViewController.swift
//  SeSac250711Report
//
//  Created by 유태호 on 7/15/25.
//

import UIKit

class adViewController: UIViewController {
    
    @IBOutlet var adLabel: UILabel!
    
    @IBOutlet var backButton: UIButton!
    
    
    // 전달받을 광고 메시지
    var adMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 바 설정
        self.title = "광고"
        
        // 전달받은 광고 메시지 표시
        if let message = adMessage {
            adLabel.text = message
        } else {
            adLabel.text = "광고 내용"
        }
        
        
        configureUI()
    }
    
    func configureUI() {
        backButton.setImage(UIImage(systemName: "x.circle"), for: .normal)
        backButton.setTitle("", for: .normal)
    }
    
    @IBAction func adBackButton(_ sender: UIButton) {
        
        dismiss(animated: true)
    }
    
    
    
}
