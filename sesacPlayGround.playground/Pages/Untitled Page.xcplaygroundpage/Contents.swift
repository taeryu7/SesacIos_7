import UIKit


/// 1. 클래스나 구조체나 사용전에는 항상 초기화가 되어 있어야한다 ViewController도 클래스라 초기화를 안하면 문제가 발생함
/// 초기값을 넣기만 하면 되는데 방법이 다양함
/// 1-1. 클래스의 모든 변수/상수를 초기화화기
/// 1-2. 옵셔널 선언 : nil이 들어있기 때문에값을 사용하면 앱이 터질 수 있음
/// 1-3. 사용하기 직전에 초기화를 해줄수 없나?
class User {
    var name: String = "jack" // 인스턴스 프로퍼티
    var age: Int = 23
    
    func hello() {
        print("ㅇㄴㅎㅅㅇ")
    }
    
    //func changeValue(name: String, age: Int) {
    init(name:String,age:Int) {
        self.name = name
        self.age = age
        
    }
    
}

//var jack = User(name: "than", age: 34) //  인스턴스 == 초기화
/// 인스턴스가 있어야 age, name 호출 가능
//
//var jack = User()
//    jack.age
//jack.name

//jack.changeValue(name: "than", age: 24)

struct Mentor {
    var name: String
    var age: Int
}

/// class는 초기화 구문이 필요한테, struct는 필요하지 않다.
/// struct는 초기화 구문을 지동으로 제공해줘서 굳이 쓸 필요 없음
/// => 멤버와이저, 이니셜라이저 구문
/// 클래스는 상속이 된다

let jack = Mentor(name: "jack", age: 23) //멤버와이저 이니셜라이저 구문


class BabyMonster {
    let nick = ""
    
    func attack() {
        print("공격")
    }
}

class BossMonster: BabyMonster {
    let name: String
    
    func bigAttack() {
        print("즉사기")
    }
    
    init(name: String) {
        self.name = name
    }
    
    
}

let m = BossMonster(name: "")
m.bigAttack()
m.attack()
