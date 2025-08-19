//
//  NetworkManager.swift
//  SeSac20250723Report
//
//  Created by 유태호 on 8/13/25.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func request<T: Decodable>(
        _ router: ShoppingRouter,
        type: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        AF.request(
            router.endpoint,
            method: router.method,
            parameters: router.parameters,
            headers: router.headers
        )
        .validate()
        .response { response in
            if let httpResponse = response.response {
                switch httpResponse.statusCode {
                case 200:
                    guard let data = response.data else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(.decodingFailed))
                    }
                    
                case 400:
                    completion(.failure(.badRequest))
                case 401:
                    completion(.failure(.unauthorized))
                case 403:
                    completion(.failure(.forbidden))
                case 429:
                    completion(.failure(.rateLimitExceeded))
                case 500...599:
                    completion(.failure(.serverError))
                default:
                    completion(.failure(.networkError))
                }
            } else {
                completion(.failure(.connectionFailed))
            }
        }
    }
}

enum NetworkError: Error {
    case badRequest
    case unauthorized
    case forbidden
    case rateLimitExceeded
    case serverError
    case networkError
    case connectionFailed
    case noData
    case decodingFailed
    
    var message: (title: String, description: String) {
        switch self {
        case .badRequest:
            return ("검색 오류", "검색어를 확인해주세요.")
        case .unauthorized:
            return ("인증 오류", "API 키 인증에 실패했습니다.")
        case .forbidden:
            return ("접근 거부", "API 사용 권한이 없습니다.")
        case .rateLimitExceeded:
            return ("요청 한도 초과", "잠시 후 다시 시도해주세요.")
        case .serverError:
            return ("서버 오류", "서버에 일시적인 문제가 발생했습니다.")
        case .networkError:
            return ("네트워크 오류", "네트워크 연결을 확인해주세요.")
        case .connectionFailed:
            return ("연결 실패", "인터넷 연결을 확인해주세요.")
        case .noData:
            return ("데이터 오류", "응답 데이터가 없습니다.")
        case .decodingFailed:
            return ("데이터 파싱 오류", "응답 데이터를 처리할 수 없습니다.")
        }
    }
}
