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
    @State var isLoading : Bool = true
    @State var lineup : [String] = []
    
    let db = Firestore.firestore()
    
    private let profileModel = ProfileModel()
    
    // private let leaderboardModel = LeaderboardModel()

    
    var body : some View {
        NavigationView() {
            ZStack {
                
                Color.gray.opacity(0.1).ignoresSafeArea()
                
                VStack {
                    Text("Leaderboard")
                        .font(.largeTitle)
                }//.navigationTitle("Leaderboard")
            }
            VStack {
                Text("Leaderboard")
                    .font(.largeTitle)
                
            }.navigationTitle("Leaderboard")
        }
    }
    
    private func fetchScore() {
            profileModel.getLineup { result in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch result {
                    case .success(let score):
                        self.lineup = score
                    case .failure(let error):
                        print("Error loading lineup: \(error.localizedDescription)")
                    }
                }
            }
        }
}
#Preview() {
    LeaderboardView()
}
//
//  LeaderboardView.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 11/12/24.
//
