//
//  LeaderboardView.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 11/12/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

/**
 Shows the current leaderboard among all users, sorted in descending order
 */
struct LeaderboardView : View {
    @State var isLoading : Bool = true
    @State var lineup : [String] = []
    @State var userDict : [String: Float] = [:]
    @State var sortedDict : [String: Float] = [:]
    @State private var errorMessage: String?
    
    private let profileModel = ProfileModel()
    
    var body : some View {
        VStack {
            Text("Leaderboard")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
                .foregroundColor(.pink)
            
            if isLoading {
                ProgressView("Loading leaderboard...")
                    .padding()
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if userDict.isEmpty {
                Text("Your user dictionary is empty!")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                
                // Sort the tuple on user's score first, and username if score is tied
                let userTupleArray = userDict.sorted{($0.value, $1.key) > ($1.value, $0.key)}
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(Array(userTupleArray.enumerated()), id:\.0) { index, item in
                            LeaderboardCardView(username: item.key, score: item.value, index: index + 1)
                        }
                        .padding()
                    }
                }
            }

        }.onAppear(){
            fetchTopUsers()
        }
        .padding()
    }
    
    func fetchTopUsers() {
        profileModel.getTopUsers() { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let userdict):
                    self.userDict = userdict
                    
                case .failure(let error):
                    print("Error loading lineup: \(error.localizedDescription)")
                }
            }
        }
    }
}

/**
 Card to represent each user
 */
struct LeaderboardCardView: View {
    let username: String
    let score: Float
    let index: Int

    var body: some View {
        HStack {
            Text("\(index)")
                .font(.title)
                .fontWeight(.bold)
                .frame(width: 40, height: 40)
                .background(Color.pink.opacity(0.2))
                .cornerRadius(20)
                .overlay(Circle().stroke(Color.pink, lineWidth: 2))
            
            Text(username)
                .font(.title)
                .fontWeight(.bold)
                .padding(.leading, 10)

            Text("\(score.formatted())")
                .font(.headline)
                .padding(.leading, 10)

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview() {
    LeaderboardView()
}

