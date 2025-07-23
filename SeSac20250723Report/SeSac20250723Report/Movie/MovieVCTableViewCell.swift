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
    
    let numberLabel = UILabel()
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureUView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieVCTableViewCell {
    
    func configureHierarchy() {
        contentView.addSubview(numberLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
    }
    
    func configureUView() {
        numberLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(15)
            make.centerY.equalTo(contentView)
            make.width.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(numberLabel.snp.trailing).offset(15)
            make.trailing.equalTo(dateLabel.snp.leading).offset(-15)
            make.centerY.equalTo(contentView)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView)
            make.width.equalTo(80)
        }
    }
    
    func configureLayout() {
        backgroundColor = .white
        
        // 숫자 라벨 설정
        numberLabel.textAlignment = .center
        numberLabel.font = .systemFont(ofSize: 16, weight: .bold)
        numberLabel.textColor = .systemBlue
        
        // 제목 라벨 설정
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .black
        
        // 날짜 라벨 설정
        dateLabel.textAlignment = .right
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .systemGray
    }
}
