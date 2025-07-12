//
//  FavoritesTableViewController.swift
//  20250708SeSacReport
//
//  Created by 유태호 on 7/10/25.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    @IBOutlet var favoritesTextLabel: UITextField!
    
    @IBOutlet var addButton: UIButton!
    
    let image = ["star.fill", "star", "checkmark.square.fill", "checkmark.square"]
    
    // 구조체
    struct TodoItem {
        var text: String
        var isChecked: Bool
        var isFavorite: Bool
        
        init(text: String) {
            self.text = text
            self.isChecked = false
            self.isFavorite = false
        }
    }
    
    // 배열
    var todoItems: [TodoItem] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
            
    }
    
    func addItem(_ text: String) {
        let newItem = TodoItem(text: text)
        todoItems.append(newItem)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath) as! FavoritesTableViewCell
        
        let item = todoItems[indexPath.row]
        
        cell.listLabel.text = item.text
        
        let checkImageName = item.isChecked ? "checkmark.square.fill" : "checkmark.square"
        let favoriteImageName = item.isFavorite ? "star.fill" : "star"
        
        cell.checkButton.setImage(UIImage(systemName: checkImageName), for: .normal)
        cell.favoriteButton.setImage(UIImage(systemName: favoriteImageName), for: .normal)
        
        cell.checkButton.tag = indexPath.row
        cell.favoriteButton.tag = indexPath.row
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    // 스와이프 삭제 활성화
    /// editingStyle
    /// 사용자가 편집 액션(삭제, 삽입 등)을 확정했을 때 호출되는 메서드
    /// 스와이프 후 "삭제" 버튼을 실제로 눌렀을 때 실행됨
    
    /// UITableViewCell.EditingStyle
    /// .delete: 삭제 액션
    /// .insert: 삽입 액션
    /// .none: 편집 없음
    
    /// forRowAt indexPath
    /// 어느 행(셀)에서 액션이 발생했는지 알려주는 위치 정보
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func favoritesTextLabelKeyboard(_ sender: UITextField) {
        
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        guard let text = favoritesTextLabel.text, !text.isEmpty else {
            print("텍스트가 비어있습니다")
            return
        }
        
        print("추가할 텍스트: \(text)")
        addItem(text)
        favoritesTextLabel.text = "" // 입력 후 텍스트 필드 초기화
    }
    


}
