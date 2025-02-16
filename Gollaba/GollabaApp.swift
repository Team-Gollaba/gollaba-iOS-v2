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
    @Environment(\.scenePhase) private var scenePhase
    private var authManager = AuthManager()
    private var pushNotificationManager = PushNotificationManager()
    
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
                .environment(pushNotificationManager)
                .onOpenURL(perform: { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                })
                .preferredColorScheme(.light)
                .onAppear {
                    ApiManager.shared.setAuthManager(authManager)
                }
                .onChange(of: scenePhase) { _, newValue in
                    if newValue == .active && authManager.isLoggedIn {
                        Task {
                            await MainViewModel.shared.getUserMe()
                        }
                    }
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
                AppStorageManager.shared.permissionForNotification = granted
                if let error {
                    Logger.shared.log("AppDelegate", #function, "Failed to request authorization: \(error.localizedDescription)", .error)
                } else if !AppStorageManager.shared.saveToNotificationServerSuccess {
                    if let token = AppStorageManager.shared.agentId {
                        Task {
                            do {
                                try await ApiManager.shared.createAppPushNotification(
                                    agentId: token,
                                    allowsNotification: granted
                                )
                            } catch {
                                
                            }
                        }
                    }
                }
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

// Cloud Messaging
extension AppDelegate: MessagingDelegate {
    
    // fcm 등록 토큰을 받았을 때
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Logger.shared.log("AppDelegate", #function, "token received: \(fcmToken ?? "")")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        
        Logger.shared.log("AppDelegate", #function, "dataDict: \(dataDict)")
        
        if AppStorageManager.shared.saveToNotificationServerSuccess && AppStorageManager.shared.agentId == fcmToken {
            return
        }
        
        if let permissionForNotification = AppStorageManager.shared.permissionForNotification, AppStorageManager.shared.agentId != fcmToken {
            Task {
                do {
                    try await ApiManager.shared.createAppPushNotification(
                        agentId: fcmToken ?? "",
                        allowsNotification: permissionForNotification
                    )
                }
            }
        }
        
        AppStorageManager.shared.agentId = fcmToken
    }
}

// User Notifications [AKA InApp Notification]
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
        NotificationCenter.default.post(name: .pushNotificationReceived, object: nil, userInfo: userInfo)
        Logger.shared.log("AppDelegate", #function, "userInfo: \(userInfo)")
        
        completionHandler()
    }
}

extension Notification.Name {
    static let pushNotificationReceived = Notification.Name("pushNotificationReceived")
}
