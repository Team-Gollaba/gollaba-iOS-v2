//
//  Logger.swift
//  Gollaba
//
//  Created by 김견 on 11/27/24.
//

import Foundation

enum LogLevel: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

class Logger {
    static let shared = Logger()
    static var isEnabled: Bool = true
    
    func log(_ className: String, _ functionName: String, _ message: String, _ level: LogLevel = .debug) {
        guard Logger.isEnabled else { return }
        
        print("[\(level.rawValue)] [\(className)] - [\(functionName)] \(message)")
    }
}
