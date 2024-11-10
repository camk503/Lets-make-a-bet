//
//  ChartsView.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 10/12/24.
//

import SwiftUI

struct ChartsView: View {
    // TODO: one connect for all views?
    @EnvironmentObject var connect : LastAPI /*= LastAPI()*/
    //TODO: If isLoading for too long, give error message
    
    // TODO: Format artist to show up or down arrow and photo
    var body: some View {
        
        // To allow for navigation between ArtistView and ArtistInfoView
        NavigationView {
            VStack {
                
                if connect.isLoading {
                    ProgressView("Loading top artists...")
                }
                else {
                    // Heading
                    Text("Top 50 Artists")
                        .font(.title)
                    
                    // Print current top artists
                    List(connect.topArtists.indices, id: \.self) { index in
                        // Some artists dont have an mbid, use index
                        let artist = connect.topArtists[index]
                        
                        // TODO: Better unwrapping
                        ArtistView(artist: artist, image: connect.images[artist.name], position: index + 1)
                            .onAppear() {
                                print("\(index+1)")
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
                
            }
            .padding()
            .onAppear() {
                connect.loadData(limit: 50)
            }
        }
    }
}

#Preview {
    ChartsView().environmentObject(LastAPI())
}
