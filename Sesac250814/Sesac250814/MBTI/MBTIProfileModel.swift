//
//  MBTIProfileModel.swift
//  Sesac250814
//
//  Created by 유태호 on 8/16/25.
//

import Foundation

struct ProfileImageItem {
    let index: Int
    let imageName: String
    let isSelected: Bool
    
    init(index: Int, isSelected: Bool = false) {
        self.index = index
        self.imageName = "char\(index + 1)"
        self.isSelected = isSelected
    }
}

struct ProfileImageGrid {
    static let totalImageCount = 48
    static let imagesPerRow = 6
    
    static func generateItems(selectedIndex: Int) -> [ProfileImageItem] {
        return (0..<totalImageCount).map { index in
            ProfileImageItem(index: index, isSelected: index == selectedIndex)
        }
    }
}
