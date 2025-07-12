//
//  DramaTableViewController.swift
//  20250708SeSacReport
//
//  Created by 유태호 on 7/10/25.
//

import UIKit
import Kingfisher

struct Drama {
    let title: String
    let date: String
    let rate: Double
    let image: String
}

class DramaTableViewController: UITableViewController {
    
    //let image = ["star.fill", "star", "heart", "heart.fill", "pencil", "xmark", "person"]
    
    let image: [Drama] = [Drama(title: "서울의 봄", date: "2023년 10월 1일", rate: 4.5, image: "star.fill"), Drama(title: "태양의후예", date: "2023년 10월 1일", rate: 4.7, image: "star.fill"), Drama(title: "도깨비", date: "2023년 10월 1일", rate: 4.9, image: "star.fill"), Drama(title: "야인시대", date: "2023년 10월 1일", rate: 5.0, image: "pencil")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.rowHeight = 60
        /// Optinal > ! , ??, ?, 옵셔널 바인딩 (if let / guard)
    }

    
    
    /// 테이블 헤더
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "드라마"
    }
    
    
    /// 세션 커스텀하게 설정하고 싶은경우 사용 (스토리보드 사용불가)
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        <#code#>
//    }
    
    // https://www.chosun.com/resizer/v2/AB4BZQEIFWKMGIBQRZHTLB2AGM.jpg?auth=7d19f35f65796f5cef90b586c7b2ed3d04cf5f7af0efcdb1f8173306cee456a9&width=616
    
    /// 섹션의 갯수를 조정할때 사용
    /// 기본이 1로 잡혀있어서 테이블뷰를 하나만 쓰는경우 써도그만 안써도 그만,
    override func numberOfSections(in tableView: UITableView) -> Int {
        return image.count
    }
    
    /// 테이블의 셀 갯수를 조정
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return image.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#function, indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "dramaCell", for: indexPath) as! DramaTableViewCell
        
//        cell.overViewLabel.numberOfLines = 0
//        cell.overViewLabel.text = "123"
//        cell.posterImageView.backgroundColor = .orange
//        cell.posterImageView.layer.cornerRadius = 10
        //cell.posterImageView.clipsToBounds = true]
        cell.overViewLabel.text = image[indexPath.row].title
        
        let name = image[indexPath.row].image
        cell.posterImageView.image = UIImage(systemName: name)
        
//        let url = URL(string:  "http://www.chosun.com/resizer/v2/AB4BZQEIFWKMGIBQRZHTLB2AGM.jpg?auth=7d19f35f65796f5cef90b586c7b2ed3d04cf5f7af0efcdb1f8173306cee456a9&width=616")
//        
//        cell.posterImageView.kf.setImage(with: url)
        
        /// 그냥 if로 설정시 4번이 아닌데도 스크롤 내리거나 올리다보면 지혼자 색상이 바뀌는 경우가 있음, 그때 나머지 영역들도 지정을 해줘야 지혼자 맛탱이가 안감
        /// 남아있는 색상값이 안사라지고 자동으로 적용되는 기현상이라 생각하면됨, 그렇기에 else문으로 컨트롤함
        /// 굳이 여기서 else문 안쓰고 다른데서도 설정가능, DramaTableViewCell 참조
        if indexPath.row == 4 {
            cell.backgroundColor = .red
        }
//        } else {
//            cell.backgroundColor = .white
//        }
        
        return cell
    }
    
    /// 셀높이
    /// 사실 있어도되고 없어도됨 viewDidLoad에서 설정 가능함
    /// tableView.rowHeight = 60 이런식으로
    /// 근데 특정 조건을 걸려면 이걸 써야됨
    /// + 하단에 if문에 else를 빼면 반환값이 없어서 오류발생함, 꼭 if - else로 빠져나가게 해야함
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(#function, indexPath.row, "heightForRowAt")
        
        if indexPath.row == 0 {
            return 100
        } else {
            return 80
        }
        
    }
    
    
    
}
