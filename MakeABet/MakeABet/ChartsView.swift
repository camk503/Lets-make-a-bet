//
//  ChartsView.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 10/12/24.
//

import SwiftUI

/**
 Displays the top 50 artist charts
 */
struct ChartsView: View {
    @EnvironmentObject var connect : LastAPI
    @EnvironmentObject var manager : FirebaseManager
    
    @State var movement : String = ""
    
    var body: some View {
        
        // To allow for navigation between ArtistView and ArtistInfoView
        NavigationView {
            ZStack {
                VStack {
                    // Show spinning wheel while loading data
                    if connect.isLoading {
                        ProgressView("Loading top artists...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .pink))
                    }
                    else {
                        if !connect.topArtists.isEmpty {
                            let _ = manager.updateArtistScores(topArtists: connect.topArtists)
                            ScrollView {
                                // Chart header
                                Text("Global Top 50")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.pink)
                                    .padding()
                                
                                LazyVStack(spacing: 15) {
                                    // Print current top artists
                                    ForEach(connect.topArtists.indices, id: \.self) { index in
                                        
                                        // Some artists dont have an mbid, use index
                                        let artist = connect.topArtists[index]

                                        // Get movement of artist on chart
                                        let movement = manager.updateMovement(for: artist.name, at: index)
                                        
                                        // Print artist info to page
                                        ArtistView (
                                            artist: artist,
                                            image: connect.images[artist.name],
                                            position: index + 1,
                                            movement: movement)
                                        .buttonStyle(PlainButtonStyle())
                                        .onAppear() {
                                            // Load image as each view appears to avoid complications
                                            if connect.images[artist.name] == nil {
                                                connect.fetchImage(artist: artist.name) { result in
                                                    switch result {
                                                    case .success(let images):
                                                        connect.images[artist.name] = images.first?.picture_big
                                                    case .failure(let error):
                                                        print("Error loading image for \(artist.name): \(error)")
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                            }.padding()
                                .background(Color.white.opacity(0.95))
                                .cornerRadius(10)
                        } else {
                            Text("No artists available :(")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.pink)
                                .padding(.top, 30)
                            Text("Please check connection and try again.")
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
            }.background(Color.gray.opacity(0.1))
        }
    }
}

#Preview {
    ChartsView()
        .environmentObject(LastAPI())
        .environmentObject(FirebaseManager())
}
