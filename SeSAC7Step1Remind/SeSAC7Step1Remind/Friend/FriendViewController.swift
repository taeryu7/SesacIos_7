//
//  FriendViewController.swift
//  SeSAC7Step1Remind
//
//  Created by Jack on 7/16/25.
//

import UIKit


/// 뷰컨트롤러에 다른객체를 넣을려면 하위 요소들을 집어넣어야함
/// 하단의 테이블뷰 사용 기준으로 테이블뷰의 요소들을 집어 넣어야함
class FriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        configureBackgroundColor()

    }
    
    func configuretableView(){
        tableView.rowHeight = 200
        let xib = UINib(nibName: "NoProfileTableViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "NoProfileTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoProfileTableViewCell", for: indexPath) as! NoProfileTableViewCell
        
        let row = list[indexPath.row]
        cell.backgroundColor = .clear
        
        cell.nameLabel.text = row.name
        cell.messageLabel.text = row.message
        if row.phone !=nil {
            cell.phoneLabel.text = "\(row.phone!)"
        } else {
            cell.phoneLabel.text = "연락처 없음"
        }
        
        if row.like {
            let image = UIImage(systemName: "heart.fill")
            cell.likeButton.setImage(image, for: .normal)
        } else {
            cell.likeButton.setImage(ImageResource.init(systemName: "heart"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: "Detail", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        
        present(vc, animated: true)
        
    }

}
