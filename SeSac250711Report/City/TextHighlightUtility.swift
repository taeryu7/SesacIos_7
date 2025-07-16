//
//  TextHighlightUtility.swift
//  SeSac250711Report
//
//  Created by 유태호 on 7/16/25.
//

import UIKit

class TextHighlightUtility {
    
    // 싱글톤 패턴 (선택사항)
    static let shared = TextHighlightUtility()
    private init() {}
    
    // 기본 하이라이트 함수
    func highlightText(
        originalText: String,
        searchKeyword: String,
        defaultTextColor: UIColor = .white,
        highlightBackgroundColor: UIColor = .systemYellow,
        highlightTextColor: UIColor = .black
    ) -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(string: originalText)
        
        // 기본 색상 설정
        attributedString.addAttribute(.foregroundColor,
                                    value: defaultTextColor,
                                    range: NSRange(location: 0, length: originalText.count))
        
        // 검색어가 없으면 기본 반환
        guard !searchKeyword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return attributedString
        }
        
        let lowercasedText = originalText.lowercased()
        let lowercasedKeyword = searchKeyword.lowercased()
        
        var searchStartIndex = 0
        
        while searchStartIndex < lowercasedText.count {
            let searchRange = NSRange(location: searchStartIndex, length: lowercasedText.count - searchStartIndex)
            let foundRange = (lowercasedText as NSString).range(of: lowercasedKeyword, options: [], range: searchRange)
            
            if foundRange.location == NSNotFound {
                break
            }
            
            // 하이라이트 적용
            attributedString.addAttributes([
                .backgroundColor: highlightBackgroundColor,
                .foregroundColor: highlightTextColor
            ], range: foundRange)
            
            searchStartIndex = foundRange.location + foundRange.length
        }
        
        return attributedString
    }
    
    // 라벨에 직접 하이라이트 적용
    func applyHighlightToLabel(
        label: UILabel,
        text: String,
        searchKeyword: String,
        defaultColor: UIColor = .white,
        highlightBgColor: UIColor = .systemYellow,
        highlightTextColor: UIColor = .black
    ) {
        
        if searchKeyword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            label.text = text
            label.textColor = defaultColor
        } else {
            let highlightedText = highlightText(
                originalText: text,
                searchKeyword: searchKeyword,
                defaultTextColor: defaultColor,
                highlightBackgroundColor: highlightBgColor,
                highlightTextColor: highlightTextColor
            )
            label.attributedText = highlightedText
        }
    }
    
    // 여러 라벨에 동시 적용
    func applyHighlightToMultipleLabels(
        labelsAndTexts: [(UILabel, String)],
        searchKeyword: String
    ) {
        for (label, text) in labelsAndTexts {
            applyHighlightToLabel(label: label, text: text, searchKeyword: searchKeyword)
        }
    }
}
