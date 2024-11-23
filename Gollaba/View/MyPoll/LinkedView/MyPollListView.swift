//
//  MyPollListView.swift
//  Gollaba
//
//  Created by 김견 on 11/24/24.
//

import SwiftUI

struct MyPollListView: View {
    @Environment(\.dismiss) var dismiss
    @State var goToPollDetail: Bool = false
    @State private var showNavigationTitle: Bool = false
    var icon: Image
    var title: String
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                Color.clear
                    .onChange(of: geometry.frame(in: .named("scroll")).minY) { _, newValue in
                        showNavigationTitle = newValue < -40
                    }
            }
            .frame(height: 0)
            
            VerticalPollList(
                goToPollDetail: $goToPollDetail,
                icon: icon,
                title: title
            )
        }
        .coordinateSpace(name: "scroll")
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
        }
        .navigationTitle(showNavigationTitle ? title : "")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $goToPollDetail) {
            PollDetailView()
        }
    }
}

#Preview {
    MyPollListView(icon: Image(systemName: "person"), title: "title")
}
