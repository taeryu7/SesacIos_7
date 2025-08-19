//
//  NetworkError.swift
//  Sesac250814
//
//  Created by 유태호 on 8/18/25.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    // HTTP 상태코드 기반
    case badRequest(message: String?)           // 400
    case unauthorized(message: String?)         // 401
    case forbidden(message: String?)            // 403
    case notFound(message: String?)             // 404
    case tooManyRequests(message: String?)      // 429 - API 한도 초과
    case serverError(message: String?)          // 500+
    
    // 네트워크 관련
    case noInternetConnection
    case timeout
    case invalidURL
    case noData
    case decodingError(Error)
    case unknownError(Error?)
    
    var userMessage: String {
        switch self {
        case .badRequest(let message):
            return message ?? "잘못된 요청입니다"
        case .unauthorized(let message):
            return message ?? "인증이 필요합니다"
        case .forbidden(let message):
            return message ?? "접근이 금지되었습니다"
        case .notFound(let message):
            return message ?? "요청한 리소스를 찾을 수 없습니다"
        case .tooManyRequests(let message):
            return message ?? "API 사용 한도를 초과했습니다. 잠시 후 다시 시도해주세요"
        case .serverError(let message):
            return message ?? "서버에 일시적인 문제가 발생했습니다"
        case .noInternetConnection:
            return "인터넷 연결을 확인해주세요"
        case .timeout:
            return "연결 시간이 초과되었습니다. 다시 시도해주세요"
        case .invalidURL:
            return "잘못된 주소입니다"
        case .noData:
            return "데이터를 받아올 수 없습니다"
        case .decodingError:
            return "데이터 처리 중 오류가 발생했습니다"
        case .unknownError:
            return "알 수 없는 오류가 발생했습니다"
        }
    }
    
    var shouldRetry: Bool {
        switch self {
        case .timeout, .noInternetConnection, .serverError, .tooManyRequests:
            return true
        case .unauthorized, .forbidden, .notFound, .badRequest:
            return false
        case .decodingError, .invalidURL, .noData:
            return false
        case .unknownError:
            return true
        }
    }
    
    var retryAfterSeconds: TimeInterval {
        switch self {
        case .tooManyRequests:
            return 60.0 // API 한도 초과시 1분 대기
        case .serverError:
            return 5.0  // 서버 에러시 5초 대기
        case .timeout, .noInternetConnection:
            return 3.0  // 네트워크 문제시 3초 대기
        default:
            return 2.0
        }
    }
    
    static func from(afError: AFError, data: Data? = nil) -> NetworkError {
        switch afError {
        case .responseValidationFailed(let reason):
            if case .unacceptableStatusCode(let code) = reason {
                return NetworkError.from(statusCode: code, data: data)
            }
            return .unknownError(afError)
        case .sessionTaskFailed(let error):
            let nsError = error as NSError
            if nsError.code == NSURLErrorNotConnectedToInternet {
                return .noInternetConnection
            } else if nsError.code == NSURLErrorTimedOut {
                return .timeout
            }
            return .unknownError(afError)
        default:
            return .unknownError(afError)
        }
    }
    
    static func from(statusCode: Int, data: Data? = nil) -> NetworkError {
        // 서버에서 온 에러 메시지 파싱 시도
        var message: String? = nil
        if let data = data {
            message = parseErrorMessage(from: data)
        }
        
        switch statusCode {
        case 400:
            return .badRequest(message: message)
        case 401:
            return .unauthorized(message: message)
        case 403:
            return .forbidden(message: message)
        case 404:
            return .notFound(message: message)
        case 429:
            return .tooManyRequests(message: message)
        case 500...599:
            return .serverError(message: message)
        default:
            return .unknownError(nil)
        }
    }
    
    private static func parseErrorMessage(from data: Data) -> String? {
        // Unsplash API 에러 응답 구조에 맞게 파싱
        struct ErrorResponse: Codable {
            let errors: [String]?
            let message: String?
        }
        
        do {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            return errorResponse.message ?? errorResponse.errors?.first
        } catch {
            return nil
        }
    }
}
