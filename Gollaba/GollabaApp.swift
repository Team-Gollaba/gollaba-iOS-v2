//
//  GollabaApp.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct GollabaApp: App {
    private var kakaoAuthManager = KakaoAuthManager()
    
    init () {
        let kakaoNativeAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey as! String)
        
        print("kakao native app key: \(kakaoNativeAppKey)")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(kakaoAuthManager)
                .onOpenURL(perform: { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                })
                .preferredColorScheme(.light)
        }
    }
}
