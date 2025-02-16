//
//  NotificationView.swift
//  Gollaba
//
//  Created by 김견 on 1/20/25.
//

import SwiftUI

struct NotificationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthManager.self) private var authManager
    @State private var viewModel = NotificationViewModel()
    
    var body: some View {
        VStack {
            NotificationList(
                pushNotificationList: viewModel.pushNotificationData?.items ?? PushNotificationData.tempDataList(),
                requestAddNotification: $viewModel.pushNotificationListRequestAdd,
                isEnd: $viewModel.pushNotificationListIsEnd
            )
            .onAppear {
                Task {
                    await viewModel.getPushNotificationList()
                }
            }
            .onChange(of: viewModel.pushNotificationListRequestAdd) { _, newValue in
                if newValue {
                    Task {
                        await viewModel.fetchPushNotificationList()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .tint(.black)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("알림 목록")
                    .font(.suitBold24)
            }
        }
        .dialog(
            isPresented: $viewModel.showErrorDialog,
            title: "푸쉬 알림",
            content: Text("\(viewModel.errorMessage)")
        )
    }
}

#Preview {
    NotificationView()
}
