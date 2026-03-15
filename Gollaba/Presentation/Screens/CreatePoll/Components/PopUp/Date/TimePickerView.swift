//
//  TimePickerView.swift
//  Gollaba
//
//  Created by 김견 on 11/24/24.
//

import SwiftUI

struct TimePickerView: View {
    @Binding var showTimerPicker: Bool
    @Binding var selectedDate: Date
    @State var showAlert: Bool = false
    
    var action: () -> Void
    
    var body: some View {
        Color.black.opacity(0.3)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                withAnimation {
                    showTimerPicker = false
                }
            }
        
        VStack {
            DatePicker(
                "시간 선택",
                selection: $selectedDate,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            
            Button {
                let currentDate = Date()
                let thirtyMinutesLater = currentDate.addingTimeInterval(30 * 60)
                
                if selectedDate < thirtyMinutesLater {
                    showAlert = true
                } else {
                    showTimerPicker = false
                }
            } label: {
                Text("완료")
                    .font(.suitBold20)
                    .foregroundStyle(.white)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(.enrollButton)
                    .cornerRadius(10)
                    .padding()
            }
        }
        .padding(8)
        .tint(.enrollButton)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.white)
        )
        .padding()
        .alert("투표 시작 날짜는 30분 이후로 설정해주세요.", isPresented: $showAlert) {
            Button("확인", role: .cancel) {}
        }
    }
    
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    TimePickerView(showTimerPicker: .constant(true), selectedDate: .constant(Date()), action: {})
}
