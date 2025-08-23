//
//  TamaSelectModel.swift
//  Sesac20250822
//
//  Created by 유태호 on 8/23/25.
//

import Foundation

enum TamagochiSlotType {
    case active(TamagochiType)
    case inactive(TamagochiType)
    case locked
}

enum TamagochiType: String, CaseIterable {
    case type1 = "1"
    case type2 = "2"
    case type3 = "3"
    
    var name: String {
        switch self {
        case .type1:
            return "따끔따끔 다마고치"
        case .type2:
            return "방실방실 다마고치"
        case .type3:
            return "반짝반짝 다마고치"
        }
    }
    
    var activeImageName: String {
        return "\(rawValue)-9"
    }
}

struct TamaSelectModel {
    let activeSlots: [ActiveTamagochiSlot]
    let collectionSlots: [CollectionTamagochiSlot]
    let isChangingMode: Bool
    let navigationTitle: String
    
    init(isChangingMode: Bool) {
        self.isChangingMode = isChangingMode
        self.navigationTitle = isChangingMode ? "다마고치 변경" : "다마고치 선택"
        
        // 활성 슬롯 생성 (3개)
        self.activeSlots = TamagochiType.allCases.map { type in
            ActiveTamagochiSlot(
                type: type,
                imageName: type.activeImageName,
                name: type.name
            )
        }
        
        // 컬렉션 슬롯 생성 (24개: 1-2~1-9, 2-2~2-9, 3-2~3-9)
        var collectionSlots: [CollectionTamagochiSlot] = []
        for stage in 2...9 {
            for type in TamagochiType.allCases {
                let imageName = "\(type.rawValue)-\(stage)"
                collectionSlots.append(
                    CollectionTamagochiSlot(
                        imageName: imageName,
                        isActive: false,
                        statusText: "준비중이에요"
                    )
                )
            }
        }
        self.collectionSlots = collectionSlots
    }
}

struct ActiveTamagochiSlot {
    let type: TamagochiType
    let imageName: String
    let name: String
}

struct CollectionTamagochiSlot {
    let imageName: String
    let isActive: Bool
    let statusText: String
}
