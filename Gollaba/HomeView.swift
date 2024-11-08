//
//  HomeView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            HStack {
                Image("AppIconImage")
                    .resizable()
                    .frame(width: 60, height: 60)
                
                Text("골라바")
                    .font(.yangjin30)
                    .underline(color: Color.titleFontColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(Color.toolbarBackgroundColor)
        }
    }
}

#Preview {
    HomeView()
}
