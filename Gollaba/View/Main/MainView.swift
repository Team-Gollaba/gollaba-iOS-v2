//
//  HomeView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI

struct MainView: View {
    @State var tabIndex: Int = 0
    
    var body: some View {
        VStack {
            TitleView()
            
            CustomTabView()
            
        }
    }
}

#Preview {
    MainView()
}
