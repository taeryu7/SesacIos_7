//
//  NetworkManager.swift
//  Sesac250814
//
//  Created by 유태호 on 8/14/25.
//

import Foundation
import Alamofire
import Network

final class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "https://api.unsplash.com"
    private let accessKey = APIKey.unsplashAccessKey
    
    // 네트워크 상태 모니터링
    private let networkMonitor = NWPathMonitor()
    private let networkQueue = DispatchQueue(label: "NetworkMonitor")
    private var isNetworkAvailable = true
    
    private init() {
        startNetworkMonitoring()
    }
    
    deinit {
        networkMonitor.cancel()
    }
    
    private func startNetworkMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isNetworkAvailable = path.status == .satisfied
                print("네트워크 상태 변경: \(path.status == .satisfied ? "연결됨" : "연결 안됨")")
            }
        }
        networkMonitor.start(queue: networkQueue)
    }
    
    func searchPhotos(
        query: String,
        page: Int = 1,
        orderBy: SortOrder = .relevant,
        colorFilter: ColorFilter? = nil,
        completion: @escaping (Result<SearchResponse, NetworkError>) -> Void
    ) {
        // 네트워크 연결 체크
        guard isNetworkAvailable else {
            completion(.failure(.noInternetConnection))
            return
        }
        
        var parameters: [String: Any] = [
            "client_id": accessKey,
            "query": query,
            "page": page,
            "per_page": 20,
            "order_by": orderBy.rawValue
        ]
        
        // 색감 필터가 선택되어 있는 경우에만 추가
        if let colorFilter = colorFilter {
            parameters["color"] = colorFilter.rawValue
        }
        
        let url = "\(baseURL)/search/photos"
        
        performRequestWithRetry(
            url: url,
            parameters: parameters,
            responseType: SearchResponse.self,
            completion: completion
        )
    }
    
    func getPhotoStatistics(
        photoId: String,
        completion: @escaping (Result<PhotoStatistics, NetworkError>) -> Void
    ) {
        guard isNetworkAvailable else {
            completion(.failure(.noInternetConnection))
            return
        }
        
        let parameters: [String: Any] = [
            "client_id": accessKey
        ]
        
        let url = "\(baseURL)/photos/\(photoId)/statistics"
        
        performRequestWithRetry(
            url: url,
            parameters: parameters,
            responseType: PhotoStatistics.self,
            completion: completion
        )
    }
    
    func getTopicPhotos(
        topicId: String,
        completion: @escaping (Result<[Photo], NetworkError>) -> Void
    ) {
        guard isNetworkAvailable else {
            completion(.failure(.noInternetConnection))
            return
        }
        
        let parameters: [String: Any] = [
            "client_id": accessKey,
            "page": 1,
            "per_page": 10
        ]
        
        let url = "\(baseURL)/topics/\(topicId)/photos"
        
        performRequestWithRetry(
            url: url,
            parameters: parameters,
            responseType: [Photo].self,
            completion: completion
        )
    }
    
    func getPhoto(
        photoId: String,
        completion: @escaping (Result<Photo, NetworkError>) -> Void
    ) {
        guard isNetworkAvailable else {
            completion(.failure(.noInternetConnection))
            return
        }
        
        let parameters: [String: Any] = [
            "client_id": accessKey
        ]
        
        let url = "\(baseURL)/photos/\(photoId)"
        
        performRequestWithRetry(
            url: url,
            parameters: parameters,
            responseType: Photo.self,
            completion: completion
        )
    }
    
    private func performRequestWithRetry<T: Decodable>(
        url: String,
        parameters: [String: Any],
        responseType: T.Type,
        retryCount: Int = 0,
        maxRetries: Int = 3,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        print("API 요청 시작: \(url) (시도: \(retryCount + 1)/\(maxRetries + 1))")
        
        AF.request(url, parameters: parameters)
            .validate()
            .responseData { [weak self] response in
                switch response.result {
                case .success(let data):
                    do {
                        let result = try JSONDecoder().decode(responseType, from: data)
                        print("API 요청 성공: \(url)")
                        completion(.success(result))
                    } catch {
                        print("데이터 파싱 실패: \(error)")
                        completion(.failure(.decodingError(error)))
                    }
                    
                case .failure(let afError):
                    let networkError = NetworkError.from(afError: afError, data: response.data)
                    print("API 요청 실패: \(networkError.userMessage)")
                    
                    // 재시도 가능한 에러이고 최대 재시도 횟수를 넘지 않았다면
                    if networkError.shouldRetry && retryCount < maxRetries {
                        let delay = networkError.retryAfterSeconds * Double(retryCount + 1)
                        
                        print("네트워크 요청 실패. \(delay)초 후 재시도... (시도: \(retryCount + 1)/\(maxRetries))")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                            self?.performRequestWithRetry(
                                url: url,
                                parameters: parameters,
                                responseType: responseType,
                                retryCount: retryCount + 1,
                                maxRetries: maxRetries,
                                completion: completion
                            )
                        }
                    } else {
                        print("재시도 불가능하거나 최대 재시도 횟수 초과: \(networkError.userMessage)")
                        completion(.failure(networkError))
                    }
                }
            }
    }
}
