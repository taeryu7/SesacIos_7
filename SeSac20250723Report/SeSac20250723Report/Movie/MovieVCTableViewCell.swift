//
//  MovieVCTableViewCell.swift
//  SeSac20250723Report
//
//  Created by 유태호 on 7/24/25.
//

import UIKit
import SnapKit

class MovieVCTableViewCell: UITableViewCell {
    
    static let identifier = "MovieVCTableViewCell"
    
    let numberLable = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieVCTableViewCell {
    
    func configureHierarchy() {
        contentView.addSubview(numberLable)
    }
    
    func configureView() {
        numberLable.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(10)
        }
    }
    
    func configureLayout() {
        numberLable.backgroundColor = .white
        
    }
}
