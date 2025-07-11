//
//  ViewController.swift
//  sesac20250703
//
//  Created by 유태호 on 7/3/25.
//

import UIKit

class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self, #function)
    }
    
    
    /// 생명주기의 +로 나온녀석
    /// ios 17일때 새로생김(ios 13부터는 적용됨)
    /// 애니메이션 기능을 동적인 무언가 핸들링 할 때 필요
    override func viewIsAppearing(_ animated: Bool) {
    }
    
    /// 뷰가 곧 나올것이다
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self, #function)
        
        view.backgroundColor = .red
    }
    
    /// 뷰가 보인다
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(self, #function)
    }
    
    
    
    /// 뷰가 사라질것이다
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(self, #function)
    }
    
    
    /// 뷰가 사라진다
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(self, #function)
    }

    @IBAction func ketBoardDissMiss(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    @IBAction func imagetapped(_ sender: UITapGestureRecognizer) {
        print(#function)
    }
    
}

