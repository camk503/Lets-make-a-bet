//
//  LeaderboardView.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 11/12/24.
//

import SwiftUI

struct LeaderboardView : View {
    var body : some View {
        NavigationView() {
            VStack {
                Text("Leaderboard")
                    .font(.largeTitle)
            }.navigationTitle("Leaderboard")
        }
    }
}
