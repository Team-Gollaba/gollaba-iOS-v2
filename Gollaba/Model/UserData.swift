//
//  UserData.swift
//  Gollaba
//
//  Created by 김견 on 12/30/24.
//

import Foundation

struct UserData: Codable {
    var name: String
    let email: String
    let roleType: String
    let providerType: String
    var profileImageUrl: String?
    var backgroundImageUrl: String?
}
