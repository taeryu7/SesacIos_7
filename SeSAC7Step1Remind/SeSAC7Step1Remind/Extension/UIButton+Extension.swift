//
//  UIButton+Extension.swift
//  SeSAC7Step1Remind
//
//  Created by 유태호 on 7/16/25.
//

import UIKit

extension UIButton {
    
    // self : 자기 자신의 인스턴스를 의미
    func configureButton(title: String) {
        self.setTitle(title, for: .normal)
        self.backgroundColor = .white
        self.setTitleColor(.black, for: .normal)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
}
