//
//  SearchViewModel.swift
//  Sesac250814
//
//  Created by 유태호 on 8/14/25.
//

import Foundation

final class SearchViewModel {
    
    struct Input {
        var searchText: Observable<String> = Observable("")
        var sortOrder: Observable<SortOrder> = Observable(.relevant)
        var selectedColorFilter: Observable<ColorFilter?> = Observable(nil)
        
        var searchTrigger: Observable<Void> = Observable(())
    }
    
    struct Output {
        var photos: Observable<[Photo]> = Observable([])
        var isLoading: Observable<Bool> = Observable(false)
        var error: Observable<String?> = Observable(nil)
        var isEmpty: Observable<Bool> = Observable(false)
    }
    
    let input = Input()
    let output = Output()
    
    init() {
        bind()
    }
    
    private func bind() {
        input.searchTrigger.bind {
            self.searchPhotos()
        }
    }
    
    private func searchPhotos() {
        let query = input.searchText.value.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !query.isEmpty else {
            output.error.value = "검색어를 입력해주세요"
            return
        }
        
        output.isLoading.value = true
        output.error.value = nil
        
        NetworkManager.shared.searchPhotos(
            query: query,
            orderBy: input.sortOrder.value,
            colorFilter: input.selectedColorFilter.value
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.output.isLoading.value = false
                
                switch result {
                case .success(let response):
                    self?.output.photos.value = response.results
                    self?.output.isEmpty.value = response.results.isEmpty
                case .failure(let error):
                    self?.output.error.value = error.userMessage
                }
            }
        }
    }
}
