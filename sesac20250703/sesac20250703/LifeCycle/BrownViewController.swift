//
//  BrownViewController.swift
//  sesac20250703
//
//  Created by 유태호 on 7/3/25.
//

import UIKit

class BrownViewController: UIViewController {
    
    let nickname = "상어"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(nickname) // scope. 가장 가까운곳의 데이터를 가져오는 특성이 있음
        print(self, #function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self, #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(self, #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(self, #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(self, #function)
    }
    
}
