//
//  DefaultResponse.swift
//  Gollaba
//
//  Created by 김견 on 11/29/24.
//

import Foundation

enum DataType: Codable {
    case boolValue(Bool)
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let boolValue = try? container.decode(Bool.self) {
            self = .boolValue(boolValue)
        } else {
            throw DecodingError.typeMismatch(DataType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected Bool value"))
        }
    }
}

struct DefaultResponse: Codable {
    let status: String
    let message: String
    let serverDateTime: String
    let data: DataType?
}
