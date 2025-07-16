//
//  ViewController.swift
//  SeSAC7Step1Remind
//
//  Created by Jack on 7/16/25.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet var goFriendButton: UIButton!
    @IBOutlet var presentTestButton: UIButton!
    @IBOutlet var pushTestButton: UIButton!
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        configureBackgroundColor()
        goFriendButton.configureButton(title: "1번버튼")
        presentTestButton.configureButton(title: "2번버튼")
        pushTestButton.configureButton(title: "3번버튼")
        
        
        // addtarget은 obj-c 시절부터 쓴거라 그 규칙이 좀 남아있음
        goFriendButton.addTarget(self, action: #selectosr(goFriendButtonTapped), for: .touchUpInside)

        
        
        
    }
    
    @objc //Swift Attributes
    func goFriendButtonTapped() {
        print(#function)
        /// 1. 어떤 스토리보드에
        //let storyboard = UIStoryboard(name: "Friend", bundle: nil)
        /// 2. 어떤 븉컨트롤러를
        let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "FriendViewController") as! FriendViewController
        
        /// 3. 어떤 방식으로 전환을 할지
        present(viewcontroller, animated: true)
    }
    



}
