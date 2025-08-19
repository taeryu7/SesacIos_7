//
//  MBTIObservable.swift
//  SesacWeek7
//
//  Created by 유태호 on 8/11/25.
//

import Foundation

class Field {
    
    private weak var owner: AnyObject?
    var action: (() -> Void)?
    
    var text: String {
        didSet {
            print("didSet", oldValue, text)
            triggerAction()
        }
    }
    
    init(_ text: String) {
        self.text = text
        print("인잇작동")
    }
    
    func playAction(owner: AnyObject, action: @escaping (() -> Void)) {
        print(#function, "start")
        self.owner = owner
        action()
        self.action = action
        print(#function, "end")
    }
    
    func playAction(action: @escaping (() -> Void)) {
        print(#function, "start")
        action()
        self.action = action
        print(#function, "end")
    }
    
    private func triggerAction() {
        guard let _ = owner else {
            action = nil
            print("액션 정리")
            return
        }
        
        action?()
    }
    
    deinit {
        action = nil
        print("필드 디인잇")
    }
}
