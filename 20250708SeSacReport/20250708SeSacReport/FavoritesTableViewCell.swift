//
//  FavoritesTableViewCell.swift
//  20250708SeSacReport
//
//  Created by 유태호 on 7/10/25.
//

import UIKit
import Kingfisher

class FavoritesTableViewCell: UITableViewCell {
    
    @IBOutlet var checkButton: UIButton!
    
    @IBOutlet var favoriteButton: UIButton!
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        if let tableView = self.superview as? UITableView,
           let viewController = tableView.dataSource as? FavoritesTableViewController {
            
            let index = sender.tag
            viewController.todoItems[index].isChecked.toggle()
            
            let imageName = viewController.todoItems[index].isChecked ? "checkmark.square.fill" : "checkmark.square"
            sender.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    @IBOutlet var listLabel: UILabel!
    
    @IBAction func favoritesbuttonTapped(_ sender: UIButton) {
        if let tableView = self.superview as? UITableView,
           let viewController = tableView.dataSource as? FavoritesTableViewController {
            
            let index = sender.tag
            viewController.todoItems[index].isFavorite.toggle()
            
            let imageName = viewController.todoItems[index].isFavorite ? "star.fill" : "star"
            sender.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    
}
