//
//  GreenViewController.swift
//  sesac20250703
//
//  Created by 유태호 on 7/3/25.
//

import UIKit

class GreenViewController: UIViewController {

    
    @IBOutlet var ButtonOne: UIButton!
    
    @IBOutlet var ButtonTwo: UIButton!
    
    @IBOutlet var ButtonThree: UIButton!
    
    
    @IBOutlet var resultLabel: UILabel!
    
    
    let randomList = ["참치", "꽁치", "새우","고등어", "연어", "광어", "도미", "우럭"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self, #function)
        
        let random = randomList.randomElement()
        print(random)
        resultLabel.text = random
        
        ButtonOne.tag = 0
        ButtonTwo.tag = 1
        ButtonThree.tag = 2
        
        
        ButtonOne.setTitle(randomList[0], for: .normal)
        ButtonTwo.setTitle("고등어", for: .normal)
        ButtonThree.setTitle("새우", for: .normal)
        
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
    
    /// Q. 하나의 액션으로 세개의 버튼을 클릭 했을 때 레이블에 글자 바꾸기
    @IBAction func ButtonOneAction(_ sender: UIButton) {
        print(#function, sender.currentTitle)
        
        /// if 조건문 .ver
        /// 조건문 : 추가한 버튼이 조건문에 없거나, 예외처리가 없을때
        //if sender == ButtonOne {
        //    resultLabel.text = "고래밥"
        //} else if sender == ButtonTwo {
        //    resultLabel.text = "상어밥"
        //} else if sender == ButtonThree {
        //    resultLabel.text = "새우밥"
        //} else {
        //    resultLabel.text = "문제가 발생했어요"
        //}
        
        /// 2. current Title
        /// currentTitle, setTitle은 ios 15 이하의 버전에서만지원함
        /// 고로 plain에서 defualt로 바꾸던가 해야함
        //resultLabel.text = sender.currentTitle
        
        /// 3. Tag
        
        print(sender.tag)
        resultLabel.text = randomList[sender.tag]
        
        
    }
    
    
    


}
