//
//  FirstTableViewController.swift
//  20250708SeSacReport
//
//  Created by 유태호 on 7/9/25.
//

import UIKit

class FirstTableViewController: UITableViewController {

    let list = ["jack", "Finn", "Den"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(#function)
    }
    
    
    /// 1. 셀 갯수: numberOfRowsInSection
    /// 몇개의 셀이 얼마나 필요한지 앞으로 알려주는 작업
    /// ex. 카카오톡 친구 300명
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        return list.count
    }
    
    /// 2. 셀 디자인 및 데이터 처리: cellForRowAt
    /// 각각 셀을 디자인을 맞춰주는것
    ///ex. 친구마다 프로필사진, 이름 등 데이터가 다 다르기때문에 맞는게 들어갈 수 있게 지정해주는것
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //복붙
        let cell = tableView.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath)
        
        print(#function, indexPath)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = list[indexPath.row]
            cell.textLabel?.textColor = .black
        } else if indexPath.row == 1 {
            cell.textLabel?.textColor = .cyan
            cell.textLabel?.text = list[indexPath.row]
        } else if indexPath.row == 2 {
            cell.textLabel?.text = list[indexPath.row]
            cell.textLabel?.textColor = .purple
        } else {
            cell.textLabel?.textColor = .white
            cell.textLabel?.backgroundColor = .gray
        }
        
        return cell
        
    }
    
    /// 3. 셀 높이: heightForRowAt
    /// 높이가 정해져있어야 그만큼 크기를 그려줄수 있기 때문에
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(#function)
        return 100
        
    }
    
    

}
