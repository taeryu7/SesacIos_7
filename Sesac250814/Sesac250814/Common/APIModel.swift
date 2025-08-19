//
//  APIModel.swift
//  Sesac250814
//
//  Created by 유태호 on 8/14/25.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let urls: PhotoURLs
    let likes: Int
    let user: PhotoUser
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height
        case urls, likes, user
    }
}

struct PhotoURLs: Decodable {
    let raw: String
    let small: String
    let regular: String?
    let thumb: String?
}

struct PhotoUser: Decodable {
    let name: String
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case name
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Decodable {
    let medium: String
}

struct SearchResponse: Decodable {
    let total: Int
    let totalPages: Int
    let results: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

enum ColorFilter: String, CaseIterable {
    case black = "black"
    case white = "white"
    case yellow = "yellow"
    case red = "red"
    case purple = "purple"
    case green = "green"
    case blue = "blue"
    
    var displayName: String {
        switch self {
        case .black: return "블랙"
        case .white: return "화이트"
        case .yellow: return "옐로우"
        case .red: return "레드"
        case .purple: return "퍼플"
        case .green: return "그린"
        case .blue: return "블루"
        }
    }
}

enum SortOrder: String, CaseIterable {
    case relevant = "relevant"
    case latest = "latest"
    case likes = "popular"
    
    var displayName: String {
        switch self {
        case .relevant: return "관련순"
        case .latest: return "최신순"
        case .likes: return "좋아요순"
        }
    }
}

struct PhotoStatistics: Decodable {
    let id: String
    let downloads: StatisticsData
    let views: StatisticsData
}

struct StatisticsData: Decodable {
    let total: Int
    let historical: HistoricalData
}

struct HistoricalData: Decodable {
    let change: Int
    let average: Int?
    let resolution: String
    let quantity: Int
    let values: [StatisticsValue]
}

struct StatisticsValue: Decodable {
    let date: String
    let value: Int
}
