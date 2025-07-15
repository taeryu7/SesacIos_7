//
//  TravleTableViewController.swift
//  SeSac250711Report
//
//  Created by 유태호 on 7/13/25.
//

import UIKit
import Kingfisher

struct Travel {
    let title: String
    let description: String?
    let travel_image: String?
    let grade: Double?
    let save: Int?
    let like: Bool?
    let ad: Bool
}

final class TravleTableViewController: UITableViewController {
    
    // TravelInfo 인스턴스 생성
    let travelInfo = TravelInfo()
    let adMessageInfo = AdMessageInfo()  // 광고 메시지 추가
    var mixedData: [(type: String, data: Travel)] = []  // 섞인 데이터 배열
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 타이틀 설정
        self.title = "여행"
        
        // 일반 여행 데이터와 광고 데이터를 섞어서 배치
        createMixedData()
    }
    
    // 일반 셀과 광고 셀을 섞어서 배치하는 함수
    func createMixedData() {
        let normalTravels = travelInfo.travel.filter { !$0.ad }  // 광고가 아닌 일반 여행지들
        let adTravels = travelInfo.travel.filter { $0.ad }       // 광고 여행지들
        
        var tempArray: [(type: String, data: Travel)] = []
        var normalIndex = 0
        var adIndex = 0
        var normalCount = 0
        
        // 2~4개의 랜덤 간격 생성
        var randomInterval = Int.random(in: 2...4)
        
        while normalIndex < normalTravels.count {
            // 일반 셀 추가
            tempArray.append((type: "normal", data: normalTravels[normalIndex]))
            normalIndex += 1
            normalCount += 1
            
            // 2~4개마다 광고 셀 추가
            if normalCount == randomInterval && adIndex < adTravels.count {
                tempArray.append((type: "ad", data: adTravels[adIndex]))
                adIndex += 1
                normalCount = 0
                
                // 다음 랜덤 간격 생성
                randomInterval = Int.random(in: 2...4)
            }
        }
        
        mixedData = tempArray
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mixedData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = mixedData[indexPath.row]
        
        if item.type == "ad" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TravleAdTableViewCell", for: indexPath) as! TravleAdTableViewCell
            let randomAdMessage = adMessageInfo.adMessages.randomElement()!
            cell.adLabel.text = randomAdMessage.title
            cell.setRandomBackgroundColor()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TravleTableViewCell", for: indexPath) as! TravleTableViewCell
            let travel = item.data
            
            cell.titleLabel.text = travel.title
            cell.descriptionLabel.text = travel.description
            
            if let grade = travel.grade {
                cell.gradeLabel.text = createStarRating(rating: grade)
            } else {
                cell.gradeLabel.text = ""
            }
            
            if let save = travel.save {
                cell.saveLabel.text = "저장 \(save)"
            } else {
                cell.saveLabel.text = ""
            }
            
            // 이미지 최적화 로딩 코드
            if let imageURL = travel.travel_image {
                Task { @MainActor in
                    ImageManager.shared.loadImageForCell(from: imageURL, into: cell.travleImageView)
                }
            } else {
                cell.travleImageView.image = UIImage(systemName: "photo")
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = mixedData[indexPath.row]
        
        if item.type == "ad" {
            return 120  // 광고 셀 고정 높이
        } else {
            return UITableView.automaticDimension  // 일반 셀 자동 높이
        }
    }
    
    // 평점을 별로 변환하는 함수
    func createStarRating(rating: Double) -> String {
        let fullStar = "★"
        let emptyStar = "☆"
        
        let fullStars = Int(rating)
        let hasHalfStar = rating - Double(fullStars) >= 0.5
        let emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0)
        
        var result = String(repeating: fullStar, count: fullStars)
        
        if hasHalfStar {
            result += "☆" // 반별 표시
        }
        
        result += String(repeating: emptyStar, count: emptyStars)
        return result
    }
    
    // URL로부터 이미지 로드하는 함수 (Magazine과 동일)
    func loadImage(from urlString: String, into imageView: UIImageView) {
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.lightGray  // 디버깅용
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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let item = mixedData[indexPath.row]
        
        if item.type == "ad" {
            // 광고 셀을 선택했을 때 FullScreen Present
            let adViewController = storyboard.instantiateViewController(withIdentifier: "adViewController") as! adViewController
            
            // 랜덤 광고 메시지 전달
            let randomAdMessage = adMessageInfo.adMessages.randomElement()!
            adViewController.adMessage = randomAdMessage.title
            
            // NavigationController로 감싸기
            let navController = UINavigationController(rootViewController: adViewController)
            navController.modalPresentationStyle = .fullScreen
            
            present(navController, animated: true)
            
        } else {
            // 일반 여행 셀을 선택했을 때 DetailTravleViewController로 Push
            let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailTravleViewController") as! DetailTravleViewController
            
            // 여행 데이터 전달
            detailViewController.travelData = item.data
            
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
