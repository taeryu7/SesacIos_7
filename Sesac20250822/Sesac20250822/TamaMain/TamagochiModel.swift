//
//  TamagochiModel.swift
//  Sesac20250822
//
//  Created by 유태호 on 8/23/25.
//

import Foundation

struct TamagochiModel {
    var level: Int
    var riceCount: Int
    var waterCount: Int
    var selectedType: String
    var ownerName: String
    
    init(level: Int = 1, riceCount: Int = 0, waterCount: Int = 0, selectedType: String = "1", ownerName: String = "대장") {
        self.level = level
        self.riceCount = riceCount
        self.waterCount = waterCount
        self.selectedType = selectedType
        self.ownerName = ownerName
    }
}

extension TamagochiModel {
    
    /// 현재 상태를 기반으로 계산된 레벨
    var calculatedLevel: Int {
        let calculated = Int((Double(riceCount) / 5.0) + (Double(waterCount) / 2.0))
        return max(1, min(10, calculated))
    }
    
    /// 다마고치 이미지명 생성
    var imageName: String {
        let imageStage = min(level, 9)
        return "\(selectedType)-\(imageStage)"
    }
    
    /// 상태 라벨 텍스트
    var statusText: String {
        return "LV.\(level) · 밥알 \(riceCount)개 · 물방울 \(waterCount)개"
    }
    
    /// 네비게이션 타이틀
    var navigationTitle: String {
        return "\(ownerName)님의 다마고치"
    }
}
