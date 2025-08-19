//
//  TopicViewModel.swift
//  Sesac250814
//
//  Created by 유태호 on 8/14/25.
//

import Foundation

class TopicViewModel {
    
    var topicSections: Observable<[TopicSection]> = Observable([])
    var isLoading: Observable<Bool> = Observable(false)
    var error: Observable<String?> = Observable(nil)
    var profileImageIndex: Observable<Int?> = Observable(nil)
    
    private let topics = Topic.allTopics
    
    init() {
        loadProfileImageIndex()
        setupInitialSections()
    }
    
    func loadAllTopicPhotos() {
        isLoading.value = true
        error.value = nil
        
        let dispatchGroup = DispatchGroup()
        var loadedSections: [TopicSection] = []
        
        // 초기화
        for topic in topics {
            loadedSections.append(TopicSection(topic: topic, photos: []))
        }
        
        // 각 토픽별로 사진 로드
        for topic in topics {
            dispatchGroup.enter()
            
            NetworkManager.shared.getTopicPhotos(topicId: topic.id) { result in
                defer { dispatchGroup.leave() }
                
                switch result {
                case .success(let photos):
                    DispatchQueue.main.async {
                        loadedSections[topic.index] = TopicSection(topic: topic, photos: photos)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("토픽 \(topic.title) 로드 실패: \(error.userMessage)")
                        // 실패해도 빈 섹션 유지
                    }
                }
            }
        }
        
        // 모든 로딩 완료 후
        dispatchGroup.notify(queue: .main) {
            self.isLoading.value = false
            self.topicSections.value = loadedSections
        }
    }
    
    func getTopicSection(at index: Int) -> TopicSection? {
        guard index < topicSections.value.count else { return nil }
        return topicSections.value[index]
    }
    
    func getPhoto(topicIndex: Int, photoIndex: Int) -> Photo? {
        guard let section = getTopicSection(at: topicIndex),
              photoIndex < section.photos.count else { return nil }
        return section.photos[photoIndex]
    }
    
    func refreshProfileImage() {
        loadProfileImageIndex()
    }
    
    private func setupInitialSections() {
        let initialSections = topics.map { TopicSection(topic: $0, photos: []) }
        topicSections.value = initialSections
    }
    
    private func loadProfileImageIndex() {
        let savedIndex = UserDefaults.standard.object(forKey: "selectedProfileImageIndex") as? Int
        profileImageIndex.value = savedIndex
    }
}
