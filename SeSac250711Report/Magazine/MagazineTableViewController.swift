//
//  MagazineTableViewController.swift
//  SeSac250711Report
//
//  Created by 유태호 on 7/12/25.
//

import UIKit
import Kingfisher  // Kingfisher import 추가

// Magazine 구조체 정의 (MagazineInfo.swift에서 사용되는 구조체)
struct Magazine {
    let title: String
    let subtitle: String
    let photo_image: String
    let date: String
    let link: String
}

class MagazineTableViewController: UITableViewController {
    
    // MagazineInfo 인스턴스 생성
    let magazineInfo = MagazineInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 타이틀 설정
        self.title = "매거진"
        
        // 테이블 뷰 설정
        /// 원인은 모르지만 테이블뷰 각 셀이 짤리는 현상으로 인해서 셀이 아예 짤리는 대참사가 발생
        /// 하단 내용은 테이블의 셀을 강제로 높이를 고정하는값
        /// 왜 짤리는지, 아니면 xcode자체에서 가변인식이 왜 안되는지 여쭤볼것 (To-do)
        /// automaticDimension : 오토레이아웃 제약조건을 보고 셀 높이를 동적으로 결정
        /// estimatedRowHeight : 테이블뷰가 스크롤바 크기를 미리 계산하기 위한 예상값
        /// 해당 두개도 호출해봤지만 씹혀서 강제높이 설정함.
        tableView.rowHeight = 460
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return magazineInfo.magazine.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MagazineTableViewCell", for: indexPath) as! MagazineTableViewCell
        
        // 현재 row의 매거진 데이터 가져오기
        let magazine = magazineInfo.magazine[indexPath.row]
        
        // 셀에 데이터 설정
        cell.MagazineTitleLabel.text = magazine.title
        cell.MagazineSubtitleLabel.text = magazine.subtitle
        cell.MagazineDateLabel.text = formatDate(magazine.date)
        
        // URL로부터 이미지 로드
        loadImage(from: magazine.photo_image, into: cell.magazineImageView)
        
        return cell
    }
    
    
    // 날짜 포맷팅 함수 (YYMMDD -> YY.MM.DD)
    func formatDate(_ dateString: String) -> String {
        guard dateString.count == 6 else { return dateString }
        
        let year = String(dateString.prefix(2))
        let month = String(dateString.dropFirst(2).prefix(2))
        let day = String(dateString.suffix(2))
        
        return "\(year).\(month).\(day)"
    }
    
    // URL로부터 이미지 로드하는 함수
    func loadImage(from urlString: String, into imageView: UIImageView) {
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.red  // 디버깅용
        imageView.layer.cornerRadius = 8
        
        // 기본 이미지 설정
        imageView.image = UIImage(systemName: "photo")
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        // 백그라운드에서 이미지 다운로드
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("이미지로딩에러: \(error)")
                return
            }
            
            guard let data = data else {
                print("데이터 없음")
                return
            }
            
            // 메인 스레드에서 이미지 설정
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    imageView.image = image
                    print("이미지로딩성공: \(urlString)")
                } else {
                    print("이미지로딩실패")
                }
            }
        }.resume()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 선택된 매거진의 링크 열기
        let magazine = magazineInfo.magazine[indexPath.row]
        if let url = URL(string: magazine.link) {
            UIApplication.shared.open(url)
        }
    }
}
