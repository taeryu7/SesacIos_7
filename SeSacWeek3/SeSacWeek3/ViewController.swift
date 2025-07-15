//
//  ViewController.swift
//  SeSACWEEK3
//
//  Created by YoungJin on 7/11/25.
//

import UIKit
import Toast

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground()
        
        print(1)
        print(2)
        print(3)
        print(4)
        print(5)
        print(6)
        print(7)
        print(7)
        print(7)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.makeToast("뷰 출현", duration: 2, position: .top)
    }

}

