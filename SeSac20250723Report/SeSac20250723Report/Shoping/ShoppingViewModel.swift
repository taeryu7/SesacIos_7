//
//  ShoppingViewModel.swift
//  SeSac20250723Report
//
//  Created by 유태호 on 8/13/25.
//

import Foundation

class ShoppingViewModel {
    
    var input: Input
    var output: Output
    
    struct Input {
        var searchButtonTapped: Observable<Void> = Observable(())
        var searchText: Observable<String?> = Observable(nil)
    }
    
    struct Output {
        var validationResult: Observable<SearchResult> = Observable(.none)
        var navigateToSearch: Observable<String?> = Observable(nil)
    }
    
    enum SearchResult {
        case none
        case success(String)
        case failure(String)
    }
    
    init() {
        input = Input()
        output = Output()
        transform()
    }
    
    private func transform() {
        input.searchButtonTapped.bind {
            let result = self.validateAndSearch(self.input.searchText.value)
            self.output.validationResult.value = result
            
            switch result {
            case .success(let keyword):
                self.output.navigateToSearch.value = keyword
            case .failure, .none:
                break
            }
        }
    }
    
    private func validateAndSearch(_ searchText: String?) -> SearchResult {
        guard let searchText = searchText, searchText.count >= 2 else {
            return .failure("2글자 이상 입력해주세요")
        }
        
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedText.count >= 2 else {
            return .failure("2글자 이상 입력해주세요")
        }
        
        return .success(trimmedText)
    }
}
