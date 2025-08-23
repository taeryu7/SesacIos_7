//
//  TamaDetailModel.swift
//  Sesac20250822
//
//  Created by 유태호 on 8/23/25.
//

import Foundation

struct TamaDetailModel {
    let tamagochiType: String
    let name: String
    let description: String
    let imageName: String
    let buttonTitle: String
    
    init(tamagochiType: String, name: String, description: String, buttonTitle: String) {
        self.tamagochiType = tamagochiType
        self.name = name
        self.description = description
        self.imageName = tamagochiType
        self.buttonTitle = buttonTitle
    }
}
