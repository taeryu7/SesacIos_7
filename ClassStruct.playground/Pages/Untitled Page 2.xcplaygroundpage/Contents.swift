import UIKit

class User {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

var color = User(name: "red")

var subcolor = color

print(color.name, subcolor.name)

subcolor.name = "blue"

print(color.name, subcolor.name)


var nickname = "orange"

var subnickname = "yellow"

print(nickname, subnickname)




/// 클래스가 가진 모든 변수(프로퍼티)는 초기화가 되어 있어야 한다
class Monster {
    
    /// 타입프로퍼티
    /// 인스턴스 생성과 상관없이 접근 할 수 있는 거
    static let game = "RPG" // 타입 프로퍼티(static)
    let name: String // 인스턴스 프로퍼티(인스턴스를 선언하고 나서 접근이 가능함)
    let level: Int
    let power: Int
    
    init(name: String, level: Int, power: Int) {
        self.name = name
        self.level = level
        self.power = power
    }
}

Monster.game


//var monster1 = Monster()  // monster1 선언과 동시에 초기화 (인스턴스 생성)
/// 몬스터 틀래스를 사용하기 위해서 공간(인스턴스)를 만듬
/// 인스턴스를 생성했다(초기화)
/// 인스턴스를 생성하고 하면, 인스턴스를 통해 프로퍼티와 메서드에 접근 할 수 있다.
var easy = Monster(name: "잡몹", level: 1, power: 1)
var normal = Monster(name: "중간보스", level: 10, power: 10)
var hard = Monster(name: "보스", level: 100, power: 100)



