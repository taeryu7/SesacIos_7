//
//  AppDelegate.swift
//  SeSACWEEK3
//
//  Created by YoungJin on 7/11/25.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 앞으로 뜨는 모든 화면의 텍스트 필드에
        // 글자크기 15. 배경오렌지. 센터
        UITextField.appearance().backgroundColor = .yellow
        UITextField.appearance().font = UIFont.boldSystemFont(ofSize: 30)
        UITextField.appearance().textAlignment = .center
        
        // 1개의 뷰컨을 제외하고 모든 뷰컨에 키보드가 없다면?
        IQKeyboardManager.shared.isEnabled = true
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

