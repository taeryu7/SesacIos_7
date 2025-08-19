//
//  LikeModel.swift
//  Sesac250814
//
//  Created by 유태호 on 8/17/25.
//

import Foundation

struct LikedPhoto {
    let photo: Photo
    let likedDate: Date?
    
    init(photo: Photo) {
        self.photo = photo
        self.likedDate = Date()
    }
}

struct LikeStorage {
    
    static func getLikedPhotoIds() -> [String] {
        let defaults = UserDefaults.standard
        let allKeys = defaults.dictionaryRepresentation().keys
        
        return allKeys.compactMap { key in
            if key.hasPrefix("liked_") && defaults.bool(forKey: key) {
                return String(key.dropFirst("liked_".count))
            }
            return nil
        }
    }
    
    static func isPhotoLiked(photoId: String) -> Bool {
        return UserDefaults.standard.bool(forKey: "liked_\(photoId)")
    }
    
    static func setPhotoLiked(photoId: String, isLiked: Bool) {
        UserDefaults.standard.set(isLiked, forKey: "liked_\(photoId)")
    }
    
    static func removeLikedPhoto(photoId: String) {
        UserDefaults.standard.removeObject(forKey: "liked_\(photoId)")
    }
}
