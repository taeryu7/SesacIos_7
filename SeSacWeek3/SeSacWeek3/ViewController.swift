//
//  ViewController.swift
//  SeSacWeek3
//
//  Created by 유태호 on 7/11/25.
//

import UIKit
import Toast

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(1)
        print(2)
        print(3)
        print(4)
        print(5)
        
        print("test")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.backgroundColor = .yellow
        
        view.makeToast("안녕하시지", duration: 2, position: .top)
    }


}

