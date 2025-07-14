//
//  TravleTableViewCell.swift
//  SeSac250711Report
//
//  Created by 유태호 on 7/13/25.
//

import UIKit

class TravleTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var gradeLabel: UILabel!
    
    @IBOutlet var saveLabel: UILabel!
    
    @IBOutlet var travleImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
