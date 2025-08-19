//
//  Observable.swift
//  Sesac250814
//
//  Created by 유태호 on 8/14/25.
//

import Foundation

class Observable<T> {
    
    private weak var owner: AnyObject?
    private var action: (() -> Void)?
    
    var value: T {
        didSet {
            triggerAction()
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(owner: AnyObject, action: @escaping () -> Void) {
        self.owner = owner
        self.action = action
        action()
    }
    
    func lazybind(owner: AnyObject, action: @escaping () -> Void) {
        self.owner = owner
        self.action = action
    }
    
    func bind(action: @escaping () -> Void) {
        self.action = action
        action()
    }
    
    func lazybind(action: @escaping () -> Void) {
        self.action = action
    }
    
    private func triggerAction() {
        guard let _ = owner else {
            action = nil
            print("액션 정리됨")
            return
        }
        
        action?()
    }
    
    deinit {
        action = nil
        print("옵저버블 디인잇")
    }
}
