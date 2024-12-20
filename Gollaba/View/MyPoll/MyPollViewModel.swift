//
//  MyPollViewModel.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI

@Observable
class MyPollViewModel {
    var goToPollDetail: Bool = false
    var goToPollList: Bool = false
    var isClickedProfileImage: Bool = false
    var isClickedLogoutButton: Bool = false
    
    var pollListIcon: Image?
    var pollListTitle: String?
}
