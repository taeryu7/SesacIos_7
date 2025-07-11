//
//  MovieTableViewController.swift
//  20250708SeSacReport
//
//  Created by 유태호 on 7/10/25.
//

import UIKit

class MovieTableViewController: UITableViewController {

    @IBOutlet var movieTextField: UITextField!
    
    var movie = ["쥬라기공원", "어벤져스", "괴물", "겨울왕국"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movie.append("xptmxm")
        movie.append("테스트")
        tableView.reloadData()
        
    }
    
    @IBAction func checkButtonClicked(_ sender: UIButton) {
        
        /// 값이 비었는지 아닌지 확인하기 위해서는 ""
//        if movieTextField.text != nil {
//            
//            if movieTextField.text!.isEmpty {
//                movie.append(movieTextField.text!)
//            }
//        }
        
        /// string? 옵셔널 스트링 타입이 맞지만, 애플이 어떻게 처리하는가
        /// nil이면 알아서 ""로 돌려주기 때문에 절대로 nil이 발생할 일이 텍스트필드에서 없다.
//        if movieTextField.text!.isEmpty {
//            
//        } else {
//            movie.append(movieTextField.text!) // 데이터가 추가되면
//            tableView.reloadData() // 데이터가 달라지면 뷰도 새로 업데이트 해줘야한다
//        }
        
        
        if movieTextField.text! != nil {
            print(movieTextField.text!)
        } else {
            print("nil")
        }
        
        tableView.reloadData()
    }
    /// 1. 셀 갯수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movie.count
    }
    
    
    /// 2. 디자인데이터
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        
        cell.textLabel?.text = movie[indexPath.row]
        
        cell.imageView?.image = UIImage(systemName: "film")
        
        print(#function, indexPath) // 재사용 매커니즘
        
        // 100% 모든셀들이 적용되도록 설정하기
        if indexPath.row == 4 {
            cell.backgroundColor = .orange
        } else {
            cell.backgroundColor = .white
        }
        
        return cell
    }
    
    /// 3. 높이
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // 셀이 클릭 됬을 때 실행되는 기능.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function, indexPath)
    }
    
}
