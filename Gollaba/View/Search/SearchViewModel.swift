//
//  SearchViewModel.swift
//  Gollaba
//
//  Created by 김견 on 12/16/24.
//

import Foundation

@Observable
class SearchViewModel {
    var searchText: String = ""
    var searchFocus: Bool = true
    
    var isFilterOpen: Bool = false
    
    var showSearchErrorToast: Bool = false
    
    func isValidSearchText() -> Bool {
        if searchText.isEmpty {
            self.showSearchErrorToast = true
            
            return false
        }
        
        return true
    }
}
