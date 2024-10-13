//
//  ContentView.swift
//  MakeABet
//
//  Created by Olivia Alexander on 10/10/24.
//

import SwiftUI

struct ContentView: View {
    @State var connect : LastAPI = LastAPI()
    @State var artists : [Artist] = []
    @State var isLoading : Bool = true
    
    // TODO: Format artist to show rank, up or down arrow, and photo
    var body: some View {
        VStack {
            
            if isLoading {
                ProgressView("Loading top artists...")
            }
            else {
                // Heading
                Text("Weekly Top 50")
                    .font(.largeTitle)
                
                // Print current top artists
                List(artists, id: \.mbid) { artist in
                    Text("\(artist.name)")
                        .font(.headline)
                }
            }
            
            /*
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")*/
        }
        .padding()
        .onAppear() {
            
                // create isLoading variable for each artist
            connect.fetchTopArtists(limit: 50) { result in
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
                    print("ERROR: \(error)")
                    
                }
            
                
            }
            
        }
    }
}

#Preview {
    ContentView(connect: LastAPI())
}
