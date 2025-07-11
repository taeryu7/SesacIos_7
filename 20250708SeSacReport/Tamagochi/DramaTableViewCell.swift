//
//  DramaTableViewCell.swift
//  20250708SeSacReport
//
//  Created by 유태호 on 7/10/25.
//

import UIKit

class DramaTableViewCell: UITableViewCell {
    
    @IBOutlet var posterImageView: UIImageView!
    
    @IBOutlet var overViewLabel: UILabel!
    
    
    /// 이건 class파일이라 안씀
//    override class func awakeFromNib() {
//        
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print(#function, "awakeFromNib")
        
        overViewLabel.numberOfLines = 0
        overViewLabel.text = "123"
        posterImageView.backgroundColor = .orange
        posterImageView.layer.cornerRadius = 10

    }
    
    
    /// 어떤 설정을 재사용 하기 위해서 사용
    override func prepareForReuse() {
        print(#function, "prepareForReuse")
        
        backgroundColor = .white
    }
    
    
    
}
