//
//  ReportDialogView.swift
//  Gollaba
//
//  Created by 김견 on 2/10/25.
//

import SwiftUI
import AlertToast

struct ReportDialogView: View {
    @Binding var isPresented: Bool
    @Binding var reportType: ReportType
    @Binding var reportReason: String
    @FocusState var isReasonFocused
    @State var showQuestionDialog: Bool = false
    @State var showCheckInvalidToast: Bool = false
    @State var invalidMessage: String = ""
    
    let onReport: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            
            VStack (alignment: .leading, spacing: 20) {
                Text("신고하기")
                    .font(.suitBold32)
                    .padding(.bottom, 12)
                
                Text("신고 유형")
                    .font(.suitBold16)
                
                Menu {
                    ForEach(ReportType.allCases, id: \.self) { reportTypeOne in
                        Button {
                            reportType = reportTypeOne
                        } label: {
                            Label(getReportText(reportType: reportTypeOne), systemImage: reportType == reportTypeOne ? "checkmark" : "")
                        }
                    }
                } label: {
                    HStack {
                        Text(getReportText(reportType: reportType))
                            .font(.suitVariable16)
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray.opacity(0.5), lineWidth: 1)
                    )
                }
                
                Text("신고 사유")
                    .font(.suitBold16)
                
                TextEditor(text: $reportReason)
                    .focused($isReasonFocused)
                    .frame(height: 100)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray.opacity(0.5), lineWidth: 1)
                    )
                
                HStack {
                    Button {
                        isPresented = false
                    } label: {
                        Text("취소")
                            .font(.suitVariable16)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.pollEndedBackground)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.pollEndedBackground)
                            )
                    }
                    
                    Button {
                        if checkValid() {
                            showQuestionDialog = true
                        }
                    } label: {
                        Text("신고하기")
                            .font(.suitVariable16)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.red)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.red)
                            )
                    }
                }
            }
            .padding(28)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
            )
            .padding()
        }
        .dialog(
            isPresented: $showQuestionDialog,
            title: "신고하기",
            content: Text("신고 하시겠습니까?"),
            secondaryButtonText: "취소",
            onPrimaryButton: {
                onReport()
            }
        )
        .toast(
            isPresenting: $showCheckInvalidToast) {
                AlertToast(type: .error(.red), title: invalidMessage, style: .style(titleFont: .suitBold16))
            }
    }
    
    private func getReportText(reportType: ReportType) -> String {
        switch reportType {
        case .spam:
            "스팸"
        case .harassment:
            "욕설 및 비방"
        case .advertisement:
            "광고"
        case .misinformation:
            "허위 정보"
        case .copyrightInfringement:
            "저작권 침해"
        case .etc:
            "기타"
        case .none:
            "선택해주세요"
        }
    }
    
    private func checkValid() -> Bool {
        if reportType == .none {
            invalidMessage = "신고 유형을 선택해주세요."
            showCheckInvalidToast = true
            return false
        } else if reportReason.isEmpty {
            invalidMessage = "신고 사유를 입력해주세요."
            showCheckInvalidToast = true
            return false
        }
        return true
    }
}

#Preview {
    ReportDialogView(isPresented: .constant(true), reportType: .constant(ReportType.etc), reportReason: .constant("reportReason\nreportReason\nreportReason\nreportReason\nreportReason\nreportReason\nreportReason\nreportReason\nreportReason\nreportReason\nreportReason\nreportReason\nreportReason\nreportReason\nreportReason\nreportReason\nreportReason\n"), onReport: {})
}
