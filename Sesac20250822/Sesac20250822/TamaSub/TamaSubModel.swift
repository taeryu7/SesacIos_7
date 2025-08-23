//
//  TamaSubModel.swift
//  Sesac20250822
//
//  Created by 유태호 on 8/23/25.
//

import Foundation

enum SettingMenuType: CaseIterable {
    case changeName
    case changeTamagochi
    case resetData
    
    var title: String {
        switch self {
        case .changeName:
            return "내 이름 변경하기"
        case .changeTamagochi:
            return "다마고치 변경하기"
        case .resetData:
            return "데이터 초기화"
        }
    }
}

struct TamaSubModel {
    let menuType: SettingMenuType
    let title: String
    let subtitle: String
    
    init(menuType: SettingMenuType, subtitle: String = "") {
        self.menuType = menuType
        self.title = menuType.title
        self.subtitle = subtitle
    }
}
