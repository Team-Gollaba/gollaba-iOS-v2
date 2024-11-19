//
//  ProfileNameView.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI

struct ProfileNameView: View {
    var name: String
    
    var body: some View {
        Text(name)
            .font(.suitBold24)
    }
}

#Preview {
    ProfileNameView(name: "Cha eun woo")
}
