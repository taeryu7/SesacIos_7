//
//  AdMessage.swift
//  SeSac250711Report
//
//  Created by 유태호 on 7/13/25.
//

import Foundation

struct AdMessage {
    let title: String
}

struct AdMessageInfo {
    let adMessages: [AdMessage] = [
        AdMessage(title: "🎉 새해 맞이 특가 항공권!"),
        AdMessage(title: "✈️ 해외여행 떠나고 싶다면?"),
        AdMessage(title: "🏖️ 여름휴가 미리 준비하세요"),
        AdMessage(title: "🎒 배낭여행 필수템 할인!"),
        AdMessage(title: "🌟 트리플 앱에서만 만나는 특가"),
        AdMessage(title: "🚗 렌터카 예약하고 자유여행!"),
        AdMessage(title: "🏨 호텔 예약 최대 70% 할인"),
        AdMessage(title: "🍜 현지 맛집 투어 예약하기"),
        AdMessage(title: "📱 여행 계획은 트리플에서"),
        AdMessage(title: "💝 친구와 함께하는 여행 할인")
    ]
}
