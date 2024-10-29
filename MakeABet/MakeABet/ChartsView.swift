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
    @State var images : [String:String] = [:]
    
    // Try dictionary for artist and image
    //@State var artistAndImage : [String:Artist] = [:]
    //TODO: If isLoading for too long, give error message
    @State var isLoading : Bool = true
    let LIMIT = 50
    
    // TODO: Format artist to show up or down arrow and photo
    var body: some View {
        
        // To allow for navigation between ArtistView and ArtistInfoView
        NavigationView {
            VStack {
                
                if isLoading {
                    ProgressView("Loading top artists...")
                }
                else {
                    // Heading
                    Text("Top \(LIMIT) Artists")
                        .font(.title)
                    
                    // Print current top artists
                    List(artists.indices, id: \.self) { index in
                        // Some artists dont have an mbid, use index
                        let artist = artists[index]
                        
                        // TODO: Better unwrapping
                        ArtistView(artist: artist, image: images[artist.name], position: index + 1)
                    }
                }
                
            }
            .padding()
            .onAppear() {
                if (isLoading) {
                    connect.fetchTopArtists(limit: LIMIT) { result in
                        switch result {
                            
                        case .success(let fetchedArtists):
                            print("SUCCESS!")
                            //self.isLoading = false
                            for artist in fetchedArtists {
                                
                                // Try to get image for artist from Deezer API
                                connect.fetchImage(artist: artist.name) { result in
                                    switch result {
                                        
                                    case .success(let fetchedImages):
                                        print("SUCCESS - images")
                                        self.isLoading = false
                                        
                                        print(artist.name)
                                        print((fetchedImages.first?.picture)!)
                                        
                                        // TODO: Better unwrapping
                                        self.images.updateValue((fetchedImages.first?.picture)!, forKey: artist.name)
                                        
                                        
                                    case .failure (let error):
                                        self.isLoading = false
                                        print("ERROR getting image for \(artist.name): \(error)")
                                    }
                                    
                                }
                                
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
}

