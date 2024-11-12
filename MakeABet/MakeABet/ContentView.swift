//
//  ContentView.swift
//  MakeABet
//
//  Created by Olivia Alexander on 10/10/24.
//

import SwiftUI

// Navigate between screens
struct ContentView: View {
    var body: some View {
        TabView() {
            // Home View
            HomeView()
                .tabItem() {
                    Label("Home", systemImage: "house")
                }
                
            // Charts View
            ChartsView()
                .tabItem() {
                    Label("Charts", systemImage: "chart.line.text.clipboard")
                }
            
            // Search View
            SearchView()
                .tabItem() {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            // Leaderboard View
            LeaderboardView()
                .tabItem() {
                    Label("Leaderboard", systemImage: "chart.bar")
                }
            
            // Profile View
            ProfileView()
                .tabItem() {
                    Label("Profile", systemImage: "person")
                }
        }

    }
}

#Preview {
    ContentView()
        .environmentObject(LastAPI())
        .environmentObject(FirebaseManager())
}
