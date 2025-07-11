//
//  MovieViewController.swift
//  sesac20250703
//
//  Created by 유태호 on 7/8/25.
//

import UIKit

/// 나만의 스트링
struct Movie {
    let title: String
    let openDate: String
    let runtime: Int
}

class MovieViewController: UIViewController {
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var movieLabel: UILabel!
    
    let list: [Movie] =  [Movie(title: "어벤져스", openDate: "2012", runtime: 134),
    Movie(title: "쥬라기공원", openDate: "2025", runtime: 120), Movie(title: "골", openDate: "2005", runtime: 140)]
//    let openDate = ["2025", "2018", "2003", "2005", "2008", "2011", "2012"]
//    let runtime = [134, 120, 117, 142, 148, 136, 118]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dateLabel.text = "2025-07-08"
        
        /// 1. 국가마다 시간이 다른것 맞춰줘야함
        /// 2.사용자 입장에 맞춰 날짜를 표현해야함
        /// 3. 오전/오후 출력
        /// 4. 요일  .EEEE 입력
        print(Date()) //current Time
        //DateFormatter().dateFormat = "yyyy-MM-dd"
        //print(DateFormatter().dateFormat = "yyyy-MM-dd")
        
        let format = DateFormatter()
        format.dateFormat = "yy년 MM월 dd일 hh시 mm분"
        let result = print(format.string(from: Date())) // 해당 코드 사용시 1번문제 해결됨
        dateLabel.text = format.string(from: Date())
        
        let componeent = DateComponents()
        print(componeent)
        
        let number = Int.random(in: 0...2)
        //movieLabel.text = "\(list[number]), \(openDate[number]), \(runtime[number])"
        movieLabel.text = "\(list[number].title)"
    }
    
    
    
    
    
}
