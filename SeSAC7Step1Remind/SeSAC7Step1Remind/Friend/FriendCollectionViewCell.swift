//
//  FriendCollectionViewCell.swift
//  SeSAC7Step1Remind
//
//  Created by 유태호 on 7/17/25.
//

import UIKit

class FriendCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.backgroundColor = .systemGray6
        profileImageView.contentMode = .scaleAspectFill
        
        nameLabel.textAlignment = .center
        nameLabel.textAlignment = .center
        
        
    }

}
