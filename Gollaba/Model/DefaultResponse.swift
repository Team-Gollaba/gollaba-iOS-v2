//
//  DefaultResponse.swift
//  Gollaba
//
//  Created by 김견 on 11/29/24.
//

import Foundation

struct DefaultResponse: Codable {
    let status: String
    let message: String
    let serverDateTime: String
}
