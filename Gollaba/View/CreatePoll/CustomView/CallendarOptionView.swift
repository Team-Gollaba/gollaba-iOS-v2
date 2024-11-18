//
//  CallendarOptionView.swift
//  Gollaba
//
//  Created by 김견 on 11/16/24.
//

import SwiftUI

struct CallendarOptionView: View {
    var today: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        HStack {
            Image(systemName: "calendar")
            
            Text(today)
                .font(.suitVariable16)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundStyle(Color.calendar)
                )
        }
    }
}

#Preview {
    CallendarOptionView()
}
