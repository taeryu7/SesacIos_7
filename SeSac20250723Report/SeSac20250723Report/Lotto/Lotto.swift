//
//  Lotto.swift
//  SeSac20250723Report
//
//  Created by 유태호 on 7/24/25.
//

import Foundation

struct LottoNumber: Decodable {
    let drwNoDate: String   // 추첨날짜
    let drwtNo1: Int        // 1번
    let drwtNo2: Int        // 2번
    let drwtNo3: Int        // 3번
    let drwtNo4: Int        // 4번
    let drwtNo5: Int        // 5번
    let drwtNo6: Int        // 6번
    let bnusNo: Int         // 7번째 숫자
    let drwNo: Int          // 회차
}
