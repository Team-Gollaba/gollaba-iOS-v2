//
//  CalendarView.swift
//  Gollaba
//
//  Created by 김견 on 11/18/24.
//

import SwiftUI

struct CalendarView: View {
    @Binding var showDatePicker: Bool
    @Binding var selectedDate: Date
    @State var showAlert: Bool = false
    var tempDate: Date?
    
    var body: some View {
        Color.black.opacity(0.3)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                withAnimation {
                    showDatePicker = false
                }
            }
        
        VStack {
            DatePicker(
                "투표 마감 날짜를 선택하세요.",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .environment(\.locale, Locale(identifier: "ko_KR"))
            .background(.white)
            .cornerRadius(10)
            .padding()
            .onChange(of: selectedDate) { oldValue, newValue in
                if newValue < Date() {
                    selectedDate = Date()
                    showAlert = true
                }
            }
            
            Button {
                withAnimation {
                    showDatePicker = false
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
        .alert("과거 날짜는 선택할 수 없습니다.", isPresented: $showAlert) {
            Button("확인", role: .cancel) {}
        }
    }
}

#Preview {
    CalendarView(showDatePicker: .constant(true), selectedDate: .constant(Date()))
}
