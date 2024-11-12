//
//  ChartsView.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 10/12/24.
//

import SwiftUI

struct ChartsView: View {
    @EnvironmentObject var connect : LastAPI
    @EnvironmentObject var manager : FirebaseManager
    
    // @State private var lastLoadedIndex = 0
    // private let batchSize = 10 // Number of images to load per batch
    
    @State var movement : String = ""

    // TODO: If isLoading for too long, give error message
    var body: some View {
        
        // To allow for navigation between ArtistView and ArtistInfoView
        NavigationView {
            ZStack {
                // Color.gray.opacity(0.1)
                VStack {
                    if connect.isLoading {
                        ProgressView("Loading top artists...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .pink))
                            .padding(.top, 50)
                    }
                    else {
                        
                        if !connect.topArtists.isEmpty {
                            ScrollView {
                                // Heading
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
                                            movement: movement
                                        )
                                        .buttonStyle(PlainButtonStyle())
                                        .onAppear() {
                                            if connect.images[artist.name] == nil {
                                                
                                                //connect.isLoadingImage = true
                                                connect.fetchImage(artist: artist.name) { result in
                                                    switch result {
                                                    case .success(let images):
                                                        connect.images[artist.name] = images.first?.picture_big
                                                        //connect.isLoadingImage = false
                                                    case .failure(let error):
                                                        print("Error loading image for \(artist.name): \(error)")
                                                        //connect.isLoadingImage = false
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
                .onAppear() {
                    // connect.isLoading = true
                    connect.loadData(limit: 50)
                    /*if !connect.topArtists.isEmpty {
                     connect.isLoading = false
                     }*/
                }
                
            }.navigationTitle("Charts")
            .background(Color.gray.opacity(0.1))
        }
    }

}

/*
private func loadImage(for artistName: String) {
    connect.fetchImage(artist: artistName) { result in
        switch result {
        case .success(let images):
            connect.images[artistName] = images.first?.picture_big
            //connect.isLoadingImage = false
        case .failure(let error):
            print("Error loading image for \(artistName): \(error)")
            //connect.isLoadingImage = false
        }
    }
}

private func loadNextImageBatch() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        // Increase the range for the next batch of images
        lastLoadedIndex = min(lastLoadedIndex + batchSize, connect.topArtists.count - 1)
    }
}
*/

#Preview {
    ChartsView()
        .environmentObject(LastAPI())
        .environmentObject(FirebaseManager())
}
