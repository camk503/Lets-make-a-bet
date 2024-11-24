//
//  LineupView.swift
//  MakeABet
//
//  Created by Nathaniel Smith on 11/19/24.
//

import SwiftUI

struct LineupView: View {
    @State private var lineup: [String] = []
    @State private var currentScore: Int = 0
    @State private var isLoading: Bool = true
    @State private var errorMessage: String?
    
    @State var connect : LastAPI = LastAPI()
    // @State var isLoading : Bool = true
    @State var artist : ArtistInfo? = nil

    let profileModel = ProfileModel()
    

    var body: some View {
        VStack {
            Text("My Lineup")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            if isLoading {
                ProgressView("Loading lineup...")
                    .padding()
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if lineup.isEmpty {
                Text("Your lineup is empty!")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        Text("Score: \(currentScore)")
                        ForEach(lineup.indices, id: \.self) { index in
                            LineupCardView(artistName: lineup[index], position: index + 1)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            fetchLineup()
            fetchScore()
        }
        .padding()
    }

    private func fetchLineup() {
        profileModel.getLineup { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let artists):
                    lineup = artists
                case .failure(let error):
                    errorMessage = "Failed to load lineup: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func fetchScore() {
        profileModel.getScore { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let score):
                    currentScore = score
                case .failure(let error):
                    errorMessage = "Failed to load score: \(error.localizedDescription)"
                }
            }
        }
    }
}


struct LineupCardView: View {
    let artistName: String
    let position: Int

    var body: some View {
        HStack {
            Text("\(position)")
                .font(.title)
                .fontWeight(.bold)
                .frame(width: 40, height: 40)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(20)
                .overlay(Circle().stroke(Color.blue, lineWidth: 2))

            Text(artistName)
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
#Preview {
    LineupView()
}
