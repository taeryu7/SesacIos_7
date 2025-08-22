//
//  HomeworkModel.swift
//  Sesac250819
//
//  Created by 유태호 on 8/21/25.
//

import Foundation

struct Person: Identifiable {
    let id = UUID()
    let name: String
    let email: String
    let profileImage: String
}
