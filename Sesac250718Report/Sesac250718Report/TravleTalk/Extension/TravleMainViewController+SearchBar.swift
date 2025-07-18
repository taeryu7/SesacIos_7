//
//  TravleMainViewController+SearchBar.swift
//  Sesac250718Report
//
//  Created by 유태호 on 7/19/25.
//

import UIKit

extension TravleMainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 실시간 검색
        applySearchFilter()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 검색 버튼 클릭 시
        searchBar.resignFirstResponder()
        applySearchFilter()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // 취소 버튼 클릭 시
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        applySearchFilter()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // 검색 시작 시 취소 버튼 표시
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // 검색 종료 시
        searchBar.showsCancelButton = false
    }
}
