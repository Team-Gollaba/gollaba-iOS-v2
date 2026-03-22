//
//  ValidationConstants.swift
//  Gollaba
//

import Foundation

enum ValidationConstants {
    static let forbiddenNicknameWords = [
        "씨발", "좆", "개새끼", "병신", "미친놈", "엿", "썅", "엿같은", "시발", "썩을", "멍청이", "바보", "븅신", "좃같은", "엿먹어",
        "성기", "야동", "포르노", "섹스", "섹시", "변태", "성인물", "AV", "자위", "성욕", "야사", "음란", "야설", "발정", "성행위", "강간", "노출",
        "흑인", "백인", "유태인", "장애인", "쪽바리", "중국놈", "왜놈", "일베", "혐오",
        "살인", "테러", "자살", "죽여", "협박", "살인자", "죽음", "무기", "총기", "학살", "납치", "폭발",
        "공산당", "민주당", "공화당", "종북", "나치", "파시스트", "레닌", "이슬람국가", "탈레반",
        "도박", "대출", "사기", "불법", "복권", "대포통장", "카드깡", "마약", "필로폰", "대마초", "아편", "마약사범", "범죄",
        "우울증", "정신병", "발암", "암덩어리", "병자", "쓸모없는", "혐오", "무가치", "비참한", "저주"
    ]

    static let specialCharRegex = "[^\\p{L}\\p{N}]"

    static func validateNickname(_ nickname: String, currentName: String? = nil) -> NickNameError {
        if nickname.isEmpty { return .Empty }
        if nickname.count < 2 || nickname.count > 10 { return .Length }
        if nickname.contains(" ") { return .ContainsBlank }
        if let currentName, currentName == nickname { return .Duplicate }
        if let regex = try? NSRegularExpression(pattern: specialCharRegex, options: []) {
            let range = NSRange(location: 0, length: nickname.utf16.count)
            if regex.firstMatch(in: nickname, options: [], range: range) != nil { return .SpecialCharacter }
        }
        for forbiddenWord in forbiddenNicknameWords {
            if nickname.contains(forbiddenWord) { return .ContainsForbiddenCharacter }
        }
        return .None
    }
}
