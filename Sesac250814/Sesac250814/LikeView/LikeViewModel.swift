//
//  LikeViewModel.swift
//  Sesac250814
//
//  Created by 유태호 on 8/17/25.
//

import Foundation

class LikeViewModel {
    
    var likedPhotos: Observable<[Photo]> = Observable([])
    var isLoading: Observable<Bool> = Observable(false)
    var isEmpty: Observable<Bool> = Observable(true)
    var error: Observable<String?> = Observable(nil)
    
    func loadLikedPhotos() {
        let likedPhotoIds = LikeStorage.getLikedPhotoIds()
        
        guard !likedPhotoIds.isEmpty else {
            updateEmptyState()
            return
        }
        
        isLoading.value = true
        error.value = nil
        
        let dispatchGroup = DispatchGroup()
        var loadedPhotos: [Photo] = []
        
        for photoId in likedPhotoIds {
            dispatchGroup.enter()
            
            NetworkManager.shared.getPhoto(photoId: photoId) { result in
                defer { dispatchGroup.leave() }
                
                switch result {
                case .success(let photo):
                    loadedPhotos.append(photo)
                case .failure(let error):
                    print("사진 로드 실패 (\(photoId)): \(error.userMessage)")
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.isLoading.value = false
            self.likedPhotos.value = loadedPhotos
            self.updateEmptyState()
        }
    }
    
    func getPhoto(at index: Int) -> Photo? {
        guard index < likedPhotos.value.count else { return nil }
        return likedPhotos.value[index]
    }
    
    func getPhotoCount() -> Int {
        return likedPhotos.value.count
    }
    
    func removeLikedPhoto(at index: Int) {
        guard index < likedPhotos.value.count else { return }
        
        let photo = likedPhotos.value[index]
        LikeStorage.removeLikedPhoto(photoId: photo.id)
        
        var updatedPhotos = likedPhotos.value
        updatedPhotos.remove(at: index)
        likedPhotos.value = updatedPhotos
        
        updateEmptyState()
    }
    
    func refreshLikedPhotos() {
        loadLikedPhotos()
    }
    
    private func updateEmptyState() {
        isEmpty.value = likedPhotos.value.isEmpty
    }
}
