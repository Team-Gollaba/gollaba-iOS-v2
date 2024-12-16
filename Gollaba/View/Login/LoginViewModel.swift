//
//  LoginViewModel.swift
//  Gollaba
//
//  Created by 김견 on 12/16/24.
//

import SwiftUI

@Observable
class LoginViewModel {
    var accessToken: String = ""
    
    func login(providerToken: String, providerType: ProviderType) async {
        do {
            accessToken = try await ApiManager.shared.loginByProviderToken(providerToken: providerToken, providerType: providerType)
        } catch {
            
        }
    }
}
