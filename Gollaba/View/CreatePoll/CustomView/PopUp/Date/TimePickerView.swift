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
        
        Button {
            
        } label: {
            VStack {
                Text("선택된 시간: \(formattedTime(selectedDate))")
                    .font(.suitBold20)
                
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
                    Text("확인")
                        .font(.suitBold16)
                        .foregroundStyle(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.enrollButton)
                        )
                }
            }
            .padding()
        }
        .tint(.black)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.white)
        )
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
