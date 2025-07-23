//
//  LottoUI.swift
//  SeSac20250723Report
//
//  Created by 유태호 on 7/24/25.
//

import UIKit

class LottoTextField: UITextField {
    // 코드로 뷰를 구성했을때 실행되는 초기화 구문
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        print("회차번호를 선택하세요")
        self.isSecureTextEntry = true
        self.borderStyle = .none
        self.font = .systemFont(ofSize: 15)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.backgroundColor = .white
        self.tintColor = .systemTeal
        self.textAlignment = .center
        
    }
    
    
    /// 스토리보드로 뷰를 구성했을때 실행되는 초기화 구분
    /// 코드로 만들더라도 스토리보드 초기화 구문을 꼭 쓰게 만듬;
    /// required 키워드는 프로토콜에 있다는걸 알려주는 역할
    required init?(coder: NSCoder) {
        print("스토리보드 init")
        fatalError( "init(coder:) has not been implemented" )
    }
}

class LottoExplanationLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = .systemFont(ofSize: 15)
        self.textAlignment = .center
        
    }
    
    required init?(coder: NSCoder) {
        print("스토리보드 init")
        fatalError( "init(coder:) has not been implemented" )
    }
}

class LottoDateLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = .systemFont(ofSize: 12)
        self.textAlignment = .center
        self.textColor = .systemGray
        
    }
    
    required init?(coder: NSCoder) {
        print("스토리보드 init")
        fatalError( "init(coder:) has not been implemented" )
    }
}

class LottoNumberMainLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = .systemFont(ofSize: 15)
        self.textAlignment = .center
        
    }
    
    required init?(coder: NSCoder) {
        print("스토리보드 init")
        fatalError( "init(coder:) has not been implemented" )
    }
}
