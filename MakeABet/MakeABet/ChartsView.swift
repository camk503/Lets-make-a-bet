//
//  ChartsView.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 10/12/24.
//

import SwiftUI

struct ChartsView: View {
    // TODO: one connect for all views?
    @State var connect : LastAPI = LastAPI()
    @State var artists : [Artist] = []
    @State var isLoading : Bool = true
    let LIMIT = 50
    
    // TODO: Format artist to show rank, up or down arrow, and photo
    // TODO: Move this to a different file
    var body: some View {
        // To allow for navigation between ArtistView and ArtistInfoView
        NavigationView {
            VStack {
                
                if isLoading {
                    ProgressView("Loading top artists...")
                }
                else {
                    // Heading
                    Text("Weekly Top \(LIMIT)")
                        .font(.title)
                    
                    // Print current top artists
                    List(artists.indices, id: \.self) { index in
                        // Some artists dont have an mbid, use index
                        let artist = artists[index]
                        
                        ArtistView(artist: artist, position: index + 1)
                    }
                }
                
            }
            .padding()
            .onAppear() {
                
                connect.fetchTopArtists(limit: LIMIT) { result in
                    switch result {
                        
                    case .success(let fetchedArtists):
                        print("SUCCESS!")
                        self.isLoading = false
                        for artist in fetchedArtists {
                            print("\(artist.name)")
                        }
                        
                        self.artists = fetchedArtists
                        
                    case .failure(let error):
                        self.isLoading = false
                        print("ERROR fetch failure: \(error)")
                        
                    }
                    
                    
                }
                
            }
        }
    }
}

