//
//  TamaMainViewController.swift
//  20250708SeSacReport
//
//  Created by 유태호 on 7/9/25.
//

import UIKit

class TamaMainViewController: UIViewController {
    
    let random: [UIColor] = [.red, .blue, .yellow, .green, .orange, .purple, .brown, .cyan]

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        navigationItem.title = "xptmxm"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = random.randomElement()
        print(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
    }
    
    
    /// 스토리보드에서 땅겨쓰는 코드가 아님
    @IBAction func unwindTamagoMainVC(_ segue: UIStoryboardSegue) {
         print("tamaMainViewController로 백")
    }

}
