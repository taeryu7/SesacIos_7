//
//  MagazineTableViewCell.swift
//  SeSac250711Report
//
//  Created by 유태호 on 7/12/25.
//

import UIKit

class MagazineTableViewCell: UITableViewCell {

    
    @IBOutlet var magazineImageView: UIImageView!
    
    @IBOutlet var MagazineTitleLabel: UILabel!
    
    @IBOutlet var MagazineSubtitleLabel: UILabel!
    
    @IBOutlet var MagazineDateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
