//
//  CreatePollView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI

struct CreatePollView: View {
    @State var text: String = ""
    @State var anonymousOption: Option = .first
    @State var countingOption: Option = .first
    @State var pollItemName: [String] = [
        "", "", "",
    ]
    @State var isQuestionPresent: Bool = false
    @State var showDatePicker: Bool = false
    @State var showTimePicker: Bool = false
    @State var selectedDate: Date = Date()
    
    @FocusState var titleFocus: Bool
    @State var viewModel = CreatePollViewModel()
    
    var body: some View {
        ScrollView {
            ZStack {
                GeometryReader { geometry in
                        Color.clear
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.isPollItemFocused = false
                                viewModel.isPollTitleFocused = false
                            }
                    }
                VStack (spacing: 16) {
                    
                    OptionBoxView(title: "투표 제목") {
                        TextField("투표의 제목을 입력해주세요.", text: $text)
                            .font(.suitVariable16)
                            .focused($titleFocus)
                    }
                    
                    CreatePollContentGridView(pollItemName: $pollItemName, selectedItem: $viewModel.selectedItem)
                        .environment(viewModel)
                        
                    
                    
                    HStack (spacing: 20) {
                        
                        OptionBoxView(title: "익명 여부") {
                            ChooseTwoOptionsView(
                                selectedOption: $anonymousOption,
                                firstOptionText: "익명 투표",
                                firstOptionImage: Image("AnonymousIcon"),
                                secondOptionText: "기명 투표",
                                secondOptionImage: Image("SignIcon")
                            )
                        }
                        
                        OptionBoxView(title: "투표 가능 옵션 개수") {
                            ChooseTwoOptionsView(
                                selectedOption: $countingOption,
                                firstOptionText: "단일 투표",
                                firstOptionImage: Image("OnlyPollIcon"),
                                secondOptionText: "복수 투표",
                                secondOptionImage: Image("PluralIcon")
                            )
                        }
                    }
                    
                    
                    OptionBoxView(title: "투표 종료 기간") {
                        CallendarOptionView(selectedDate: $selectedDate, action: {
                            withAnimation {
                                showDatePicker = true
                            }
                        })
                    }
                    
                    OptionBoxView(title: "투표 종료 시간") {
                        TimerOptionView(selectedDate: $selectedDate) {
                            withAnimation {
                                showTimePicker = true
                            }
                        }
                    }
                    
                    QuestionButton {
                        isQuestionPresent = true
                    }
                    
                    EnrollPollButton {
                        
                    }
                    
                }
                .padding()
                .dialog(
                    isPresented: $isQuestionPresent,
                    title: "투표 만들기 도움말",
                    content: questionHelpContent,
                    primaryButtonText: "확인",
                    onPrimaryButton: {}
                )
                .onChange(of: viewModel.isPollTitleFocused) { oldValue, newValue in
                    titleFocus = newValue
                }
                .onChange(of: titleFocus) { oldValue, newValue in
                    viewModel.isPollTitleFocused = newValue
                }
                
                if showDatePicker {
                    CalendarView(
                        showDatePicker: $showDatePicker,
                        selectedDate: $selectedDate
                    )
                }
                
                if showTimePicker {
                    TimePickerView(
                        showTimerPicker: $showTimePicker,
                        selectedDate: $selectedDate,
                        action: {}
                    )
                }
            }
        }
        
    }
    
    private var questionHelpContent: Text {
            Text("기명투표")
                .font(.suitBold16)
            + Text("를 선택하여 로그인 된 사용자의 투표만 받을 수 있어요.")
                .font(.suitVariable16)
            + Text("\n\n복수투표")
                .font(.suitBold16)
            + Text("로 여러 선택지를 동시에 고르도록 할 수 있어요.")
                .font(.suitVariable16)
            + Text("\n\n마감일")
                .font(.suitBold16)
            + Text("을 설정해 투표 기간을 원하는 만큼 지정할 수 있어요.")
                .font(.suitVariable16)
        }
}

#Preview {
    CreatePollView()
}
