//
//  NotificationList.swift
//  Gollaba
//
//  Created by 김견 on 1/28/25.
//

import SwiftUI

struct NotificationList: View {
    let pushNotificationList: [PushNotificationData]
    
    @Binding var requestAddNotification: Bool
    @Binding var isEnd: Bool
    
    var refreshAction: () async -> Void
    
    var body: some View {
        if !pushNotificationList.isEmpty {
            ScrollView {
                ScrollViewReader { _ in
                    VStack {
                        ForEach(pushNotificationList, id: \.notificationId) { pushNotificationData in
                            NotificationContentView(pushNotificationData: pushNotificationData)
                            
                            if pushNotificationData.notificationId != pushNotificationList.last?.notificationId {
                                Divider()
                                    .padding(.horizontal)
                            }
                        }
                        
                        if !isEnd {
                            GollabaLoadingView()
                        }
                        
                        Color.clear
                            .frame(height: 0)
                            .id("Bottom")
                            .background(
                                GeometryReader { geometry in
                                    Color.clear
                                        .onChange(of: geometry.frame(in: .global).minY) { _, newValue in
                                            if newValue < UIScreen.main.bounds.height + 100 && !isEnd {
                                                requestAddNotification = true
                                            }
                                        }
                                }
                            )
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity)
            .refreshable {
                await refreshAction()
            }
        } else {
            Text("받은 알림이 없습니다.")
                .font(.suitBold24)
        }
        
        
    }
}

#Preview {
    NotificationList(pushNotificationList: [], requestAddNotification: .constant(false), isEnd: .constant(false), refreshAction: { @Sendable in})
}
