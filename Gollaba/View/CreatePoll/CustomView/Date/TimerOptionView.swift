//
//  TimerOptionView.swift
//  Gollaba
//
//  Created by 김견 on 11/24/24.
//

import SwiftUI

struct TimerOptionView: View {
    @State private var showTimePicker: Bool = false
    @Binding var selectedDate: Date
    var action: () -> Void
    
    var body: some View {
        ZStack {
            Button {
                action()
            } label: {
                HStack {
                    Image(systemName: "stopwatch")
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
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    TimerOptionView(selectedDate: .constant(Date()), action: {})
}
