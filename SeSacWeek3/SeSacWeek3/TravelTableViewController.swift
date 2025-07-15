//
//  TravelTableViewController.swift
//  SeSACWEEK3
//
//  Created by YoungJin on 7/14/25.
//

struct Travel {
    let name: String
    let overView: String
    let date: String
    let like: Bool
}

import UIKit

class TravelTableViewController: UITableViewController {
    
    let format = DateFormatter() // 연산비용, 인스턴스 생성 비용 크다
    
    let travel = [
        Travel(name: "서울", overView: "선유도공원 좋아요", date: "250406", like: false),
        Travel(name: "인천", overView: "인천 좋아요", date: "250113", like: true),
        Travel(name: "대구", overView: "대구 좋아요", date: "251217", like: false),
        Travel(name: "부산", overView: "부산 좋아요", date: "250522", like: true),
        Travel(name: "제주도", overView: "제주도 좋아요", date: "250814", like: false),
    ] // 국가, 설명, 좋아요

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        // XIB Cell 로 구성하는 순간, 필요한 코드
        // 셀 등록
        let xib = UINib(nibName: "TravelTableViewCell",
                        bundle: nil) // 나의 프로젝트 안에서 가져오는 것이라면 nil, 외부 셀 사용 시 작성
        tableView.register(xib, forCellReuseIdentifier: "TravelTableViewCell")
     
        tableView.rowHeight = UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return travel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelTableViewCell", for: indexPath) as! TravelTableViewCell
        
        cell.configureUI(travel[indexPath.row])
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        if indexPath.row < 3 {
//            return UITableView.automaticDimension
//        } else {
//            return 100
//        }
// 
//    }

}
