//
//  ShopingSearchUI.swift
//  SeSac20250723Report
//
//  Created by 유태호 on 7/26/25.
//

import UIKit

// 검색 결과 개수 표시 라벨
class SearchResultCountLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = .systemFont(ofSize: 14)
        self.textColor = .systemTeal
        self.textAlignment = .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
}

// 정렬 버튼 컴포넌트
class SortButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel?.font = .systemFont(ofSize: 14)
        self.setTitleColor(.black, for: .normal)
        self.backgroundColor = .systemGray6
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
}
