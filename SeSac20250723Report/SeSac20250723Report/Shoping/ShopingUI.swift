//
//  ShopingUI.swift
//  SeSac20250723Report
//
//  Created by 유태호 on 7/26/25.
//

import UIKit

class ShoppingTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.text = "Shopping"
        self.font = .systemFont(ofSize: 24, weight: .bold)
        self.textColor = .white
        self.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        print("스토리보드 init")
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
}

class ShoppingSearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.placeholder = "브랜드, 상품, 프로필, 태그 등"
        self.searchBarStyle = .minimal
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        print("스토리보드 init")
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
}

class ShoppingImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemGray6
        self.layer.cornerRadius = 10
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        print("스토리보드 init")
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
}

class ShoppingSubLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.text = "원하는 상품을 검색해보세요"
        self.font = .systemFont(ofSize: 16)
        self.textColor = .systemGray
        self.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        print("스토리보드 init")
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
}
