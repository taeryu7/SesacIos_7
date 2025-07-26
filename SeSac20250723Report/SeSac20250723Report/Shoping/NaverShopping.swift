//
//  NaverShopping.swift
//  SeSac20250723Report
//
//  Created by 유태호 on 7/26/25.
//

import Foundation

// 네이버 쇼핑 API 응답 모델
struct NaverShoppingResponse: Decodable {
    let total: Int              // 전체 검색 결과 개수
    let items: [ShoppingItem]   // 상품 리스트
}

// 개별 상품 정보 모델
struct ShoppingItem: Decodable {
    let title: String           // 상품명 (HTML 태그 포함)
    let image: String           // 상품 이미지 URL
    let mallName: String        // 쇼핑몰명
    let lprice: String          // 최저가 (문자열)
}
