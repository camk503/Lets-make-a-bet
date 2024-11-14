//
//  LeaderboardView.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 11/12/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct LeaderboardView : View {
    
    let db = Firestore.firestore()
    
    var body : some View {
        NavigationView() {
            VStack {
                Text("Leaderboard")
                    .font(.largeTitle)
                
            }.navigationTitle("Leaderboard")
        }
    }
}
