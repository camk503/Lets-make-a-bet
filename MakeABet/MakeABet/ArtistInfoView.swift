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
                    Text("\(artist.artistInfo.name.capitalized)")
                        .font(.title)
                }
                VStack(alignment: .leading) {
                    Text("PLAYCOUNT")
                        .font(.system(size: 16))
                    Text("\(artist.artistInfo.stats.playcount)")
                        .font(.subheadline)
                }
                VStack(alignment: .leading) {
                    Text("LISTENERS")
                        .font(.system(size: 16))
                    Text("\(artist.artistInfo.stats.listeners)")
                        .font(.subheadline)
                }
                Text("Biography\n\(artist.artistInfo.bio.summary)")
            }
            
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

