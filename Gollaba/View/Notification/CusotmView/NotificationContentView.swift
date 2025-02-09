//
//  NotificationContentView.swift
//  Gollaba
//
//  Created by 김견 on 1/21/25.
//

import SwiftUI

struct NotificationContentView: View {
    let pushNotificationData: PushNotificationData
    
    var body: some View {
        HStack (alignment: .top, spacing: 12) {
            ProfileImageView(width: 60, height: 60)
            
            VStack (alignment: .leading, spacing: 8) {
                HStack {
                    Text(pushNotificationData.title)
                        .font(.suitBold16)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Spacer()
//                    
//                    Text(pushNotificationData.content)
//                        .font(.suitVariable16)
//                        .foregroundStyle(.gray)
                }
                
                Text(pushNotificationData.content)
                    .font(.suitVariable16)
            }
        }
        .padding()
    }
}

#Preview {
    NotificationContentView(pushNotificationData: PushNotificationData(notificationId: 1, userId: 1, agentId: "agentId", eventId: nil, deepLink: "deepLink", title: "title", content: "content"))
}
