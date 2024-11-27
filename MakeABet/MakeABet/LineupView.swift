//
//  LineupView.swift
//  MakeABet
//
//  Created by Nathaniel Smith on 11/19/24.
//

import SwiftUI

struct LineupView: View {
    // @State private var lineup: [String] = []
    // @State private var currentScore: Float = 0
    // @State private var isLoading: Bool = true
    @State private var errorMessage: String?
    
    @State var connect : LastAPI = LastAPI()
    @State var artist : ArtistInfo? = nil

    @EnvironmentObject var profileModel : ProfileModel
    @EnvironmentObject var manager : FirebaseManager
    

    var body: some View {
        ZStack() {
            Color.gray.opacity(0.1).ignoresSafeArea()
            
            VStack {
                Text("My Lineup")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                    .foregroundColor(.pink)
                
                if profileModel.isLoading {
                    ProgressView("Loading lineup...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .pink))
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else if profileModel.lineup.isEmpty {
                    Text("Your lineup is empty!")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding()
                    Text("Go to the charts page to start adding artists!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .fontWeight(.semibold)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(profileModel.lineup.indices, id: \.self) { index in
                                LineupCardView(artistName: profileModel.lineup[index], position: index + 1)
                            }
                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                profileModel.fetchScore()
            }
            .padding()
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
                .background(Color.pink.opacity(0.2))
                .cornerRadius(20)
                .overlay(Circle().stroke(Color.pink, lineWidth: 2))

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
    LineupView().environmentObject(ProfileModel())
}
