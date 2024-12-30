//
//  GollabaApp.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI
import SwiftData
import KakaoSDKCommon
import KakaoSDKAuth
import FirebaseCore
import Firebase
import FirebaseMessaging

@main
struct GollabaApp: App {
    private var authManager = AuthManager()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init () {
        let kakaoNativeAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey as! String)
        
        print("kakao native app key: \(kakaoNativeAppKey)")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [SearchKeyword.self])
                .environment(authManager)
                .onOpenURL(perform: { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                })
                .preferredColorScheme(.light)
                .onAppear {
                    ApiManager.shared.setAuthManager(authManager)
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            
            let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOption
            ) { granted, error in
                Logger.shared.log("AppDelegate", #function, "granted: \(granted)")
                
            }
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Logger.shared.log("AppDelegate", #function, "DeviceToken: \(deviceToken.base64EncodedString())")
        
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Logger.shared.log("AppDelegate", #function, "token received: \(fcmToken ?? "")")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        
        Logger.shared.log("AppDelegate", #function, "dataDict: \(dataDict)")
        
        
    }
}

@available(iOS 10.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 푸시 메시지가 앱이 켜져있을 때 나올 경우
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            Logger.shared.log("AppDelegate", #function, "messageID: \(messageID)")
        }
        
        Logger.shared.log("AppDelegate", #function, "userInfo: \(userInfo)")
        
        completionHandler([[.banner, .badge, .sound]])
    }
    
    // 푸시 알림 받았을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            Logger.shared.log("AppDelegate", #function, "messageID: \(messageID)")
        }
        
        Logger.shared.log("AppDelegate", #function, "userInfo: \(userInfo)")
        
        completionHandler()
    }
}
