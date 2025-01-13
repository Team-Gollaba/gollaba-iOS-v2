//
//  CallendarOptionView.swift
//  Gollaba
//
//  Created by 김견 on 11/16/24.
//

import SwiftUI

struct CallendarOptionView: View {
    @State private var showDatePicker: Bool = false
    @Binding var selectedDate: Date
    var action: () -> Void
    
    var body: some View {
        ZStack {
            Button {
                action()
            } label: {
                HStack {
                    Image(systemName: "calendar")
                    Text(formattedDate(selectedDate))
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
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
}

#Preview {
    CallendarOptionView(selectedDate: .constant(Date()), action: {})
}
