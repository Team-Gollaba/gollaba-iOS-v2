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
        NavigationLink {
            PollDetailView(id: getPollHashId())
        } label: {
            HStack (alignment: .top, spacing: 12) {
                Image(systemName: "checkmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(.green)
                    .padding(12)
                    .background(
                        Circle()
                            .fill(.green.opacity(0.1))
                    )
                    .skeleton(isActive: pushNotificationData.notificationId == -1)
                
                VStack (alignment: .leading, spacing: 8) {
                    HStack {
                        Text(pushNotificationData.title)
                            .font(.suitBold20)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        Spacer()
                    }
                    .skeleton(isActive: pushNotificationData.notificationId == -1)
                    
                    Text(pushNotificationData.content)
                        .font(.suitVariable16)
                        .skeleton(isActive: pushNotificationData.notificationId == -1)
                }
                
                VStack {
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12)
                    
                    Spacer()
                }
            }
            .padding()
        }
        .tint(.black)
        .disabled(pushNotificationData.notificationId == -1)
    }
    
    private func getPollHashId() -> String {
        if let url = URLComponents(string: pushNotificationData.deepLink ?? ""),
           let queryItems = url.queryItems?.first(where: { $0.name == "pollHashId"}) {
            return queryItems.value ?? ""
        }
        return ""
    }
}

#Preview {
    NotificationContentView(pushNotificationData: PushNotificationData(notificationId: 1, userId: 1, deepLink: "deepLink", title: "title", content: "content"))
}
