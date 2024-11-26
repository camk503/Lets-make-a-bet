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
    @State var userDict : [String: Float] = [:]
    @State var sortedDict : [String: Float] = [:]
    @State private var errorMessage: String?
    //@State var count : Int = 0
    
    private let profileModel = ProfileModel()
    
    var body : some View {
        VStack {
            //Color.gray.opacity(0.1).ignoresSafeArea()

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
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(Array(userDict.keys.enumerated()),id:\.element) { index, user in
                            LeaderboardCardView(username: user, score: userDict[user] ?? 0, index: index + 1)

                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear(){
            fetchTopUsers()
        }
        .padding()
    }
    
    
    private func fetchTopUsers() {
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
//
//  LeaderboardView.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 11/12/24.
//


/*
 NavigationView() {
     ZStack {
         
         Color.gray.opacity(0.1).ignoresSafeArea()
         
         VStack {
             Text("Leaderboard")
                 .font(.largeTitle)
         }//.navigationTitle("Leaderboard")
     }
 */
