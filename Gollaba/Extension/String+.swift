//
//  String+.swift
//  Gollaba
//
//  Created by 김견 on 12/29/24.
//

import Foundation

extension String {
    var forceCharWrapping: Self {
        self.map({ String($0) }).joined(separator: "\u{200B}") // 200B: 가로폭 없는 공백문자
    }
}
