//
//  CreatePollView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI

struct CreatePollView: View {
    @Environment(AuthManager.self) var authManager
    @State var viewModel = CreatePollViewModel()
    @Binding var isHideTabBar: Bool
    
    var body: some View {
        ZStack {
            ScrollView {
                ZStack {
                    GeometryReader { geometry in
                        Color.clear
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.isPollItemFocused = false
                                viewModel.titleFocus = false
                                viewModel.creatorNameFocus = false
                            }
                    }
                    VStack (spacing: 16) {
                        
                        OptionBoxView(title: "투표 작성자") {
                            
                            ClearableTextFieldView(
                                placeholder: "투표 작성자 이름을 입력해주세요.",
                                editText: $viewModel.creatorNameText,
                                isFocused: $viewModel.creatorNameFocus
                                )
                            .onAppear {
                                if authManager.isLoggedIn {
                                    viewModel.creatorNameText = authManager.name
                                }
                            }
                        }
                        
                        OptionBoxView(title: "투표 제목") {
                            
                            ClearableTextFieldView(
                                placeholder: "투표의 제목을 입력해주세요.",
                                editText: $viewModel.titleText,
                                isFocused: $viewModel.titleFocus
                            )
                        }
                        
                        CreatePollContentGridView(pollItemName: $viewModel.pollItemName, selectedItem: $viewModel.selectedItem)
                            .environment(viewModel)
                        
                        
                        
                        HStack (spacing: 20) {
                            
                            OptionBoxView(title: "익명 여부") {
                                ChooseTwoOptionsView(
                                    selectedOption: $viewModel.anonymousOption,
                                    firstOptionText: "익명 투표",
                                    firstOptionImage: Image("AnonymousIcon"),
                                    secondOptionText: "기명 투표",
                                    secondOptionImage: Image("SignIcon")
                                )
                            }
                            
                            OptionBoxView(title: "투표 가능 옵션 개수") {
                                ChooseTwoOptionsView(
                                    selectedOption: $viewModel.countingOption,
                                    firstOptionText: "단일 투표",
                                    firstOptionImage: Image("OnlyPollIcon"),
                                    secondOptionText: "복수 투표",
                                    secondOptionImage: Image("PluralIcon")
                                )
                            }
                        }
                        
                        
                        OptionBoxView(title: "투표 종료 기간") {
                            CallendarOptionView(selectedDate: $viewModel.selectedDate, action: {
                                withAnimation {
                                    viewModel.showDatePicker = true
                                }
                            })
                        }
                        
                        OptionBoxView(title: "투표 종료 시간") {
                            TimerOptionView(selectedDate: $viewModel.selectedDate) {
                                withAnimation {
                                    viewModel.showTimePicker = true
                                }
                            }
                        }
                        
                        EnrollPollButton {
                            if viewModel.isValidForCreatePoll() {
                                Task {
                                    await viewModel.createPoll()
                                }
                            }
                        }
                        
                    }
                    .padding()
                    
                    if viewModel.showDatePicker {
                        CalendarView(
                            showDatePicker: $viewModel.showDatePicker,
                            selectedDate: $viewModel.selectedDate
                        )
                    }
                    
                    if viewModel.showTimePicker {
                        TimePickerView(
                            showTimerPicker: $viewModel.showTimePicker,
                            selectedDate: $viewModel.selectedDate,
                            action: {}
                        )
                    }
                    
                }
            }
//            .dragToHide(isHide: $isHideTabBar)
            .dialog(
                isPresented: $viewModel.isQuestionPresent,
                title: "투표 만들기 도움말",
                content: questionHelpContent,
                primaryButtonText: "확인",
                onPrimaryButton: {}
            )
            .dialog(
                isPresented: $viewModel.showCompletedDialog,
                title: "투표 만들기",
                content: Text(viewModel.completedMessage),
                primaryButtonText: "확인",
                onPrimaryButton: {
                    if viewModel.isCompletedCreatePoll {
                        viewModel.goToPollDetail = true
                    }
                }
            )
            .dialog(
                isPresented: $viewModel.showErrorDialog,
                title: "투표 만들기 오류",
                content: Text("\(viewModel.errorMessage)")
            )
            
            VStack {
                Spacer()
                
                QuestionButton {
                    viewModel.isQuestionPresent = true
                }
                .padding()
            }
        }
        .navigationDestination(isPresented: $viewModel.goToPollDetail) {
            PollDetailView(id: viewModel.pollHashId)
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
    CreatePollView(isHideTabBar: .constant(false))
}
