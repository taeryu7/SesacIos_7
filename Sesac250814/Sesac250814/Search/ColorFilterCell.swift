//
//  ColorFilterCell.swift
//  Sesac250814
//
//  Created by 유태호 on 8/14/25.
//

import UIKit
import SnapKit

class ColorFilterCell: UICollectionViewCell {
    
    private let containerView = UIView()
    private let colorView = UIView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray4.cgColor
        containerView.backgroundColor = .white
        
        colorView.layer.cornerRadius = 5
        colorView.layer.borderWidth = 1
        colorView.layer.borderColor = UIColor.systemGray5.cgColor
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(colorView)
        containerView.addSubview(titleLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        colorView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(4)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(colorView.snp.trailing).offset(3)
            make.trailing.equalToSuperview().offset(-6)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with colorFilter: ColorFilter, isSelected: Bool) {
        titleLabel.text = colorFilter.displayName
        
        // 색상 표시
        colorView.backgroundColor = getUIColor(for: colorFilter)
        
        // 선택 상태 표시
        if isSelected {
            containerView.backgroundColor = .systemBlue
            containerView.layer.borderColor = UIColor.systemBlue.cgColor
            titleLabel.textColor = .white
        } else {
            containerView.backgroundColor = .white
            containerView.layer.borderColor = UIColor.systemGray4.cgColor
            titleLabel.textColor = .black
        }
    }
    
    private func getUIColor(for colorFilter: ColorFilter) -> UIColor {
        switch colorFilter {
        case .black: return .black
        case .white: return .white
        case .yellow: return .yellow
        case .red: return .red
        case .purple: return .purple
        case .green: return .green
        case .blue: return .blue
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let labelSize = titleLabel.intrinsicContentSize
        return CGSize(width: labelSize.width + 30, height: 30)
    }
}
