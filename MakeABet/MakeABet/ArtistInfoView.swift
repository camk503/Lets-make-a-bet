//
//  ArtistInfoView.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 10/14/24.
//
import SwiftUI

/**
 View to get the description of a music artist
 */
struct ArtistInfoView : View {
    @State var connect : LastAPI = LastAPI()
    @State var isLoading : Bool = true
    @State var artist : ArtistInfo? = nil
    
   
    let name : String
    let image : String?
    let position : Int
    
    
    var body : some View {
        VStack {
            if isLoading {
                ProgressView("Loading information for \(name)...")
            }
            // If not nil
            else if let artist = artist {
                
                if let imageString = image,let imageURL = URL(string: imageString) {
                    
                    AsyncImage (
                        url: imageURL,
                        content: { img in
                            img.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300, height: 300)
                        
                        },
                        placeholder: {
                            ProgressView()
                        }
                    )
                                    
                }
                
                HStack {
                    Text("#\(position)")
                    Text("\(artist.name.capitalized)")
                        .font(.title)
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text("PLAYCOUNT")
                            .font(.system(size: 16))
                        Text(LastAPI.formatNumber(number: artist.stats.playcount))
                            .font(.subheadline)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("LISTENERS")
                            .font(.system(size: 16))
                        Text(LastAPI.formatNumber(number: artist.stats.listeners))
                            .font(.subheadline)
                    }
                }
                
                Text("Biography\n").bold()
                Text("\(artist.bio.summary)")
                
            }
            
            // TODO: Keep button at bottom while scrolling
            Button("+ Add to lineup") {
                print("Implement add to lineup here")
            }
            .buttonStyle(.borderedProminent)
            
        }
        .padding()
        .onAppear() {
            
            if (isLoading) {
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
    
}

#Preview {
    ArtistInfoView(name: "Radiohead", image: "https://e-cdns-images.dzcdn.net/images/artist/9508c1217e880b52703a525d1bd5250c/250x250-000000-80-0-0.jpg", position: 1)
}
