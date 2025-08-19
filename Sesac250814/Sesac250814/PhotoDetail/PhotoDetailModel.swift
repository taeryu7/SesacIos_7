//
//  PhotoDetailModel.swift
//  Sesac250814
//
//  Created by 유태호 on 8/14/25.
//

import Foundation

struct PhotoDetailInfo {
    let photo: Photo
    let formattedDate: String
    let sizeText: String
    let isLiked: Bool
    
    init(photo: Photo) {
        self.photo = photo
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: photo.createdAt) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "yyyy년 MM월 dd일"
            self.formattedDate = displayFormatter.string(from: date)
        } else {
            self.formattedDate = ""
        }
        
        self.sizeText = "크기: \(photo.width) × \(photo.height)"
        self.isLiked = UserDefaults.standard.bool(forKey: "liked_\(photo.id)")
    }
}

struct StatisticsInfo {
    let viewsText: String
    let downloadsText: String
    
    init(statistics: PhotoStatistics) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        self.viewsText = "조회수: \(formatter.string(from: NSNumber(value: statistics.views.total)) ?? "\(statistics.views.total)")"
        self.downloadsText = "다운로드: \(formatter.string(from: NSNumber(value: statistics.downloads.total)) ?? "\(statistics.downloads.total)")"
    }
    
    static var empty: StatisticsInfo {
        return StatisticsInfo(viewsText: "조회수: 정보 없음", downloadsText: "다운로드: 정보 없음")
    }
    
    private init(viewsText: String, downloadsText: String) {
        self.viewsText = viewsText
        self.downloadsText = downloadsText
    }
}

struct ChartDataItem: Identifiable {
    let id = UUID()
    let date: Date
    let value: Int
}

enum ChartType: Int, CaseIterable {
    case views = 0
    case downloads = 1
    
    var title: String {
        switch self {
        case .views: return "조회수"
        case .downloads: return "다운로드"
        }
    }
}

struct ChartDataProcessor {
    static func processStatistics(_ statistics: PhotoStatistics, type: ChartType) -> [ChartDataItem] {
        let values = type == .views ? statistics.views.historical.values : statistics.downloads.historical.values
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return values.compactMap { value in
            guard let date = dateFormatter.date(from: value.date) else { return nil }
            return ChartDataItem(date: date, value: value.value)
        }
    }
    
    static func createSampleData() -> [ChartDataItem] {
        let calendar = Calendar.current
        let today = Date()
        
        var sampleData: [ChartDataItem] = []
        
        for i in (0..<30).reversed() {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                let randomValue = Int.random(in: 100...1000)
                sampleData.append(ChartDataItem(date: date, value: randomValue))
            }
        }
        
        return sampleData
    }
}
