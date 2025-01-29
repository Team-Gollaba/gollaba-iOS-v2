//
//  SelectablePollContent.swift
//  Gollaba
//
//  Created by 김견 on 11/18/24.
//

import SwiftUI
import Kingfisher


struct SelectablePollContent: View {
    var pollOption: PollOption
    
    var responseType: ResponseType
    var isSelected: Bool
    @Binding var activateSelectAnimation: Bool
    
    var action: () -> Void
    
    @State private var showAnimation: Bool = false
    @State private var isPresentZoomView: Bool = false
    
    var body: some View {
        ZStack {
            VStack (spacing: 0) {
                Group {
                    if let imageUrl = pollOption.imageUrl {
                        KFImage(URL(string: imageUrl))
                            .resizable()
                            .scaledToFill()
                            .clipped()
                    } else {
                        Image(systemName: "photo.badge.plus")
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .foregroundStyle(.white)
                .background(
                    Color.attach
                )
                
                
                HStack {
                    ZStack {
                        OptionSelectButton(isSelected: isSelected, responseType: responseType) {
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 12)
                        
                        Text(pollOption.description)
                            .font(.suitBold16)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 28)
                .background(
                    isSelected ? Color.selectedPoll : Color.toolbarBackground
                )
            }
            .frame(width: UIScreen.main.bounds.width / 2 - 24)
            .background(
                Color.white
            )
            .cornerRadius(10)
            .shadow(radius: 2)
            .scaleEffect(showAnimation ? 1.1 : 1.0)
            .animation(.bouncy(duration: 0.2), value: showAnimation)
            
            if pollOption.imageUrl != nil {
                VStack {
                    HStack {
                        Spacer()
                        
                        Button {
                            isPresentZoomView = true
                        } label: {
                            Image(systemName: "plus.magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.white)
                                .frame(width: 16, height: 16)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.gray.opacity(0.7))
                                )
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            action()
        }
        .onChange(of: activateSelectAnimation) { _, newValue in
            
            if newValue && isSelected {
                showAnimation = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    showAnimation = false
                }
            }
            activateSelectAnimation = false
        }
        .sheet(isPresented: $isPresentZoomView) {
            ImageDetailView(imageUrl: pollOption.imageUrl ?? "")
        }
    }
}

#Preview {
    SelectablePollContent(pollOption: PollOption(id: 1, description: "des", imageUrl: nil, votingCount: 1), responseType: .multiple, isSelected: true, activateSelectAnimation: .constant(false), action: {})
}
