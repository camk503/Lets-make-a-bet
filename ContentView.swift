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
        VStack(spacing: 0) {
            HStack() {
                // Top Bar
                Text("Let's Make A Bet")
                    .foregroundColor(.pink)
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                    .padding()
                
                Spacer()
                
                Text(" Score ")
                    .fontWeight(.bold)
                    .padding(4)
                    .background(.pink)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    
                    
            }.background(.gray.opacity(0.1))
            
            Divider()
            
            TabView() {
                // Home View
                LineupView()
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
            .accentColor(.pink)
            .background(.white)
            .ignoresSafeArea(edges: .bottom)
            
            
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LastAPI())
        .environmentObject(FirebaseManager())
}
