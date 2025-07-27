//
//  BoxOffice.swift
//  SeSac20250723Report
//
//  Created by 유태호 on 7/27/25.
//

import Foundation

// 데이터 구조체
struct BoxOfficeResponse: Codable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Codable {
    let dailyBoxOfficeList: [DailyBoxOffice]
}

struct DailyBoxOffice: Codable {
    let rank: String
    let movieNm: String
    let openDt: String
}


// api 연동 코드
struct BoxOffice {
    static let apiKey = ""
    
    static func fetchDailyBoxOffice(for date: String, completion: @escaping (Result<[DailyBoxOffice], Error>) -> Void) {
        guard isValidDate(date) else {
            completion(.failure(BoxOfficeError.invalidDate))
            return
        }
        
        let urlString = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(apiKey)&targetDt=\(date)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(BoxOfficeError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(BoxOfficeError.noData))
                return
            }
            
            do {
                let boxOfficeResponse = try JSONDecoder().decode(BoxOfficeResponse.self, from: data)
                completion(.success(boxOfficeResponse.boxOfficeResult.dailyBoxOfficeList))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private static func isValidDate(_ dateString: String) -> Bool {
        return dateString.count == 8 && dateString.allSatisfy { $0.isNumber }
    }
}

// 에러시 출력
enum BoxOfficeError: LocalizedError {
    case invalidDate
    case invalidURL
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidDate:
            return "올바른 날짜 형식을 입력해주세요. (YYYYMMDD)"
        case .invalidURL:
            return "잘못된 URL입니다."
        case .noData:
            return "데이터를 받을 수 없습니다."
        }
    }
}
