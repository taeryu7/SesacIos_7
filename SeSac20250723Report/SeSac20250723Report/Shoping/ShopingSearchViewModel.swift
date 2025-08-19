//
//  ShopingSearchViewModel.swift
//  SeSac20250723Report
//
//  Created by 유태호 on 8/13/25.
//

import Foundation

final class ShopingSearchViewModel {
    
    var input: Input
    var output: Output
    
    struct Input {
        var initialSearch: Observable<String> = Observable("")
        var sortChanged: Observable<SortType> = Observable(.accuracy)
        var loadNextPage: Observable<Void> = Observable(())
    }
    
    struct Output {
        var shoppingItems: Observable<[ShoppingItem]> = Observable([])
        var randomItems: Observable<[ShoppingItem]> = Observable([])
        var isMainLoading: Observable<Bool> = Observable(false)
        var isPaginationLoading: Observable<Bool> = Observable(false)
        var error: Observable<NetworkError?> = Observable(nil)
        var totalCountText: Observable<String> = Observable("")
    }
    
    // 페이지네이션 관련 프로퍼티
    private let itemsPerPage = 30
    private var currentPage = 1
    private var isLoading = false
    private var hasMoreData = true
    private var currentSortType: SortType = .accuracy
    private var searchKeyword: String = ""
    private var totalCount: Int = 0
    
    init() {
        input = Input()
        output = Output()
        transform()
    }
    
    private func transform() {
        input.initialSearch.bind {
            guard !self.input.initialSearch.value.isEmpty else { return }
            self.searchKeyword = self.input.initialSearch.value
            self.resetPagination()
            self.requestShoppingAPI()
        }
        
        input.sortChanged.bind {
            guard self.input.sortChanged.value != self.currentSortType else { return }
            self.currentSortType = self.input.sortChanged.value
            self.resetPagination()
            self.requestShoppingAPI()
        }
        
        input.loadNextPage.bind {
            guard self.canLoadMore() else { return }
            self.requestShoppingAPI()
        }
    }
    
    private func resetPagination() {
        currentPage = 1
        output.shoppingItems.value = []
        output.randomItems.value = []
        hasMoreData = true
    }
    
    private func canLoadMore() -> Bool {
        return !isLoading && hasMoreData
    }
    
    func shouldLoadNextPage(currentIndex: Int) -> Bool {
        return currentIndex >= output.shoppingItems.value.count - 5
    }
    
    func getCurrentSortType() -> SortType {
        return currentSortType
    }
    
    private func updateRandomItems() {
        guard output.shoppingItems.value.count > 0 else {
            output.randomItems.value = []
            return
        }
        
        let shuffled = output.shoppingItems.value.shuffled()
        output.randomItems.value = Array(shuffled.prefix(10))
    }
    
    private func requestShoppingAPI() {
        guard !searchKeyword.isEmpty else { return }
        guard !isLoading && hasMoreData else { return }
        
        isLoading = true
        
        // 로딩 상태 설정
        if currentPage == 1 {
            output.isMainLoading.value = true
        } else {
            output.isPaginationLoading.value = true
        }
        
        let router = ShoppingRouter.search(
            query: searchKeyword,
            page: currentPage,
            sort: currentSortType
        )
        
        NetworkManager.shared.request(router, type: NaverShoppingResponse.self) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.output.isMainLoading.value = false
                self.output.isPaginationLoading.value = false
                
                switch result {
                case .success(let response):
                    self.handleSuccessResponse(response)
                case .failure(let error):
                    self.output.error.value = error
                }
            }
        }
    }
    
    private func handleSuccessResponse(_ response: NaverShoppingResponse) {
        print("API 성공: 페이지 \(currentPage), 아이템 수: \(response.items.count)")
        
        if currentPage == 1 {
            output.shoppingItems.value = response.items
            totalCount = response.total
            updateRandomItems()
            updateTotalCountText()
        } else {
            output.shoppingItems.value.append(contentsOf: response.items)
        }
        
        let loadedCount = (currentPage - 1) * itemsPerPage + response.items.count
        hasMoreData = response.items.count == itemsPerPage && loadedCount < response.total
        
        currentPage += 1
    }
    
    private func updateTotalCountText() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let countString = formatter.string(from: NSNumber(value: totalCount)) ?? "\(totalCount)"
        output.totalCountText.value = "\(countString) 개의 검색 결과"
    }
}
