//
//  SearchView.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 10/17/24.
//  HELPFUL DOCS:
//      Search: https://developer.apple.com/documentation/swiftui/adding-a-search-interface-to-your-app
//

import SwiftUI

struct SearchView : View {
    /*
     0 = Artists
     1 = Songs
     2 = Profiles
     */
    @State var page : Int = 0
    
    var body: some View {
        VStack {
            HStack {
                Button("Search Artists") {
                    page = 0
                }
                Button("Search Songs") {
                    page = 1
                }
                Button("Search Profiles") {
                    page = 2
                }
            }
            
        }
    }
    
}
