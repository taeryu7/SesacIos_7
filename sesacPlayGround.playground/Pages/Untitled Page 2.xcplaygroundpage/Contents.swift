//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"


class Mentor {
    
    func mentoring() {
        print("멘토링")
    }
}

class Den: Mentor {
    
    func study() {
        print("공부")
    }
    
    override func mentoring() {
        print("멘토링")
        super.mentoring()
        print("화이팅")
    }
    
}

let den = Den()
den.mentoring()
den.study()

//: [Next](@next)
