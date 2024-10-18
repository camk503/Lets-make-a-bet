//
//  ArtistInfoView.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 10/14/24.
//
import SwiftUI

struct ArtistInfoView : View {
    @State var connect : LastAPI = LastAPI()
    @State var isLoading : Bool = true
    @State var artist : ArtistInfoResponse? = nil
    
    let name : String
    let position : Int
    
    var body : some View {
        VStack {
            if isLoading {
                ProgressView("Loading information for \(name)...")
            }
            // If not nil
            else if let artist = artist {
                
                HStack {
                    Text("#\(position)")
                    Text("\(artist.artist.name.capitalized)")
                        .font(.title)
                }
                VStack(alignment: .leading) {
                    Text("PLAYCOUNT")
                        .font(.system(size: 16))
                    Text("\(artist.artist.stats.playcount)")
                        .font(.subheadline)
                }
                VStack(alignment: .leading) {
                    Text("LISTENERS")
                        .font(.system(size: 16))
                    Text("\(artist.artist.stats.listeners)")
                        .font(.subheadline)
                }
                Text("Biography\n\(artist.artist.bio.summary)")
            }
            
            Button("+ Add to lineup") {
                print("Implement add to lineup here")
            }
            .buttonStyle(.borderedProminent)
            
        }
        .padding()
        .onAppear() {
            
            connect.fetchArtist(artist: name) { result in
                switch result {
                    
                case .success(let fetchedArtist):
                    print("SUCCESS!")
                    self.isLoading = false
                    
                    self.artist = fetchedArtist
                    
                case .failure(let error):
                    self.isLoading = false
                    print("ERROR fetch failure: \(error)")
                    
                }
            
                
            }
            
        }
    }
    
}

