//
//  TopicModel.swift
//  Sesac250814
//
//  Created by 유태호 on 8/14/25.
//

import Foundation

struct Topic {
    let title: String
    let id: String
    let index: Int
    
    static let allTopics = [
        Topic(title: "골든아워", id: "6sMVjTLSkeQ", index: 0),
        Topic(title: "비즈니스 및 업무", id: "business-work", index: 1),
        Topic(title: "건축 및 인테리어", id: "interiors", index: 2)
    ]
}

struct TopicSection {
    let topic: Topic
    let photos: [Photo]
    
    var isEmpty: Bool {
        return photos.isEmpty
    }
}
