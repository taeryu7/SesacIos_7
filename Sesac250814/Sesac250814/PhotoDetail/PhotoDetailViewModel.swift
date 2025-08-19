//
//  PhotoDetailViewModel.swift
//  Sesac250814
//
//  Created by 유태호 on 8/14/25.
//

import Foundation

class PhotoDetailViewModel {
    
    private let photo: Photo
    private var statistics: PhotoStatistics?
    
    var photoDetailInfo: Observable<PhotoDetailInfo>
    var statisticsInfo: Observable<StatisticsInfo> = Observable(StatisticsInfo.empty)
    var isLoading: Observable<Bool> = Observable(false)
    var selectedChartType: Observable<ChartType> = Observable(.views)
    var chartData: Observable<[ChartDataItem]> = Observable([])
    var showToast: Observable<String?> = Observable(nil)
    
    init(photo: Photo) {
        self.photo = photo
        self.photoDetailInfo = Observable(PhotoDetailInfo(photo: photo))
        setupBindings()
    }
    
    private func setupBindings() {
        selectedChartType.bind { [weak self] in
            self?.updateChartData()
        }
    }
    
    func loadStatistics() {
        isLoading.value = true
        
        NetworkManager.shared.getPhotoStatistics(photoId: photo.id) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading.value = false
                
                switch result {
                case .success(let statistics):
                    self?.statistics = statistics
                    self?.statisticsInfo.value = StatisticsInfo(statistics: statistics)
                    self?.updateChartData()
                case .failure(let error):
                    print("Statistics 로드 실패: \(error.userMessage)")
                    self?.statisticsInfo.value = StatisticsInfo.empty
                    self?.chartData.value = ChartDataProcessor.createSampleData()
                }
            }
        }
    }
    
    func toggleLike() {
        let currentLikedState = UserDefaults.standard.bool(forKey: "liked_\(photo.id)")
        let newLikedState = !currentLikedState
        
        UserDefaults.standard.set(newLikedState, forKey: "liked_\(photo.id)")
        
        let updatedInfo = PhotoDetailInfo(photo: photo)
        photoDetailInfo.value = updatedInfo
        
        let message = newLikedState ? "좋아요에 추가되었습니다" : "좋아요에서 제거되었습니다"
        showToast.value = message
    }
    
    func selectChartType(index: Int) {
        guard let chartType = ChartType(rawValue: index) else { return }
        selectedChartType.value = chartType
    }
    
    private func updateChartData() {
        guard let statistics = statistics else {
            chartData.value = ChartDataProcessor.createSampleData()
            return
        }
        
        let processedData = ChartDataProcessor.processStatistics(statistics, type: selectedChartType.value)
        chartData.value = processedData.isEmpty ? ChartDataProcessor.createSampleData() : processedData
    }
    
    func getProfileImageURL() -> String {
        return photo.user.profileImage.medium
    }
    
    func getMainImageURL() -> String {
        return photo.urls.regular ?? photo.urls.small
    }
}
