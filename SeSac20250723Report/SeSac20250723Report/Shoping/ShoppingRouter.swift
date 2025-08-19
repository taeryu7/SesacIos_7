//
//  ShoppingRouter.swift
//  SeSac20250723Report
//
//  Created by 유태호 on 8/13/25.
//

import Foundation
import Alamofire

enum ShoppingRouter {
    case search(query: String, page: Int, sort: SortType)
    
    var baseURL: String {
        return "https://openapi.naver.com/v1"
    }
    
    var endpoint: URL {
        switch self {
        case .search:
            return URL(string: baseURL + "/search/shop.json")!
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters {
        switch self {
        case .search(let query, let page, let sort):
            let startIndex = (page - 1) * 30 + 1
            return [
                "query": query,
                "display": 30,
                "start": startIndex,
                "sort": sort.rawValue
            ]
        }
    }
    
    var headers: HTTPHeaders {
        return [
            "X-Naver-Client-Id": APIKey.naverID,
            "X-Naver-Client-Secret": APIKey.naverSecret
        ]
    }
}
