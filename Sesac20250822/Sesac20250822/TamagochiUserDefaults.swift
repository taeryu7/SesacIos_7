//
//  TamagochiUserDefaults.swift
//  20250708SeSacReport
//
//  Created by 유태호 on 8/22/25.
//

import Foundation

class TamagochiUserDefaults {
    
    static let shared = TamagochiUserDefaults()
    private init() {}
    
    // UserDefaults 키 상수
    private enum Keys {
        static let selectedTamagochiType = "selectedTamagochiType"
        static let tamagochiLevel = "tamagochiLevel"
        static let riceCount = "riceCount"
        static let waterCount = "waterCount"
        static let tamagochiName = "tamagochiName"
        static let isFirstLaunch = "isFirstLaunch"
    }
    
    // 다마고치 상태 저장 (stage 제거, level만 사용)
    func saveTamagochiData(level: Int, riceCount: Int, waterCount: Int) {
        UserDefaults.standard.set(level, forKey: Keys.tamagochiLevel)
        UserDefaults.standard.set(riceCount, forKey: Keys.riceCount)
        UserDefaults.standard.set(waterCount, forKey: Keys.waterCount)
    }
    
    // 다마고치 상태 로드
    func loadTamagochiLevel() -> Int {
        return UserDefaults.standard.integer(forKey: Keys.tamagochiLevel) == 0 ? 1 : UserDefaults.standard.integer(forKey: Keys.tamagochiLevel)
    }
    
    func loadRiceCount() -> Int {
        return UserDefaults.standard.integer(forKey: Keys.riceCount)
    }
    
    func loadWaterCount() -> Int {
        return UserDefaults.standard.integer(forKey: Keys.waterCount)
    }
    
    // MARK: - 다마고치 이름 관리
    func saveTamagochiName(_ name: String) {
        UserDefaults.standard.set(name, forKey: Keys.tamagochiName)
    }
    
    func loadTamagochiName() -> String {
        return UserDefaults.standard.string(forKey: Keys.tamagochiName) ?? "대장 다마고치"
    }
    
    // 다마고치 타입 관리
    func saveSelectedTamagochiType(_ type: String) {
        UserDefaults.standard.set(type, forKey: Keys.selectedTamagochiType)
    }
    
    func loadSelectedTamagochiType() -> String {
        return UserDefaults.standard.string(forKey: Keys.selectedTamagochiType) ?? "1-1"
    }
    
    // 최초 실행 여부
    func setFirstLaunchCompleted() {
        UserDefaults.standard.set(true, forKey: Keys.isFirstLaunch)
    }
    
    func isFirstLaunch() -> Bool {
        return !UserDefaults.standard.bool(forKey: Keys.isFirstLaunch)
    }
    
    // 데이터 초기화
    func resetAllData() {
        UserDefaults.standard.removeObject(forKey: Keys.selectedTamagochiType)
        UserDefaults.standard.removeObject(forKey: Keys.tamagochiLevel)
        UserDefaults.standard.removeObject(forKey: Keys.riceCount)
        UserDefaults.standard.removeObject(forKey: Keys.waterCount)
        UserDefaults.standard.removeObject(forKey: Keys.tamagochiName)
        UserDefaults.standard.removeObject(forKey: Keys.isFirstLaunch)
    }
}
