//
//  SearchFilterView.swift
//  Gollaba
//
//  Created by 김견 on 12/16/24.
//

import SwiftUI

struct SearchFilterView: View {
    @Binding var isFilterOpen: Bool
    @Binding var sortedBy: SortedBy
    @Binding var pollTypeFilter: [Bool]
    @Binding var isActiveFilter: [Bool]
    var applyAction: () -> Void
    
    var body: some View {
        Color.gray
            .edgesIgnoringSafeArea(.all)
            .opacity(0.5)
            .onTapGesture {
                isFilterOpen = false
                initFilter()
            }
        
        VStack (alignment: .leading, spacing: 20) {
            HStack {
                Text("투표 검색 필터")
                    .font(.yangjin20)
                
                Image(systemName: "line.3.horizontal.decrease")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Spacer()
                
                SortingView(sortedBy: $sortedBy)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
//            SearchFilterContentView(
//                title: "생성 날짜",
//                firstOption: "오래된순",
//                secondOption: "최신순",
//                selected: $madeDateFilter
//            )
            
            SearchFilterContentView(
                title: "기명/익명",
                firstOption: "기명",
                secondOption: "익명",
                selected: $pollTypeFilter
            )
            
            SearchFilterContentView(
                title: "진행/종료",
                firstOption: "진행중",
                secondOption: "종료",
                selected: $isActiveFilter
            )
            
            HStack (spacing: 20) {
                Button {
                    isFilterOpen = false
                    initFilter()
                } label: {
                    Text("취소")
                        .font(.suitBold16)
                        .foregroundStyle(.red)
                }
                
                Button {
                    isFilterOpen = false
                    applyAction()
                } label: {
                    Text("적용")
                        .font(.suitBold16)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 40)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 0)
                
        )
    }
    
    func initFilter() {
//        madeDateFilter = [true, false, false]
        pollTypeFilter = [true, false, false]
        isActiveFilter = [true, false, false]
    }
}

#Preview {
    SearchFilterView(isFilterOpen: .constant(true), sortedBy: .constant(.createdAt), pollTypeFilter: .constant([]), isActiveFilter: .constant([]), applyAction: {})
}
