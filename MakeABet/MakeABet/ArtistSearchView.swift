//
//  ArtistSearchView.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 10/17/24.
//

import SwiftUI

/**
 How an artist appears on the SEARCH page
 Takes in an Artist object from SearchView
 */
struct ArtistSearchView: View {
    var artist : Artist
    var image : String?
    
    private let DEFAULT : String = "https://lastfm.freetls.fastly.net/i/u/34s/2a96cbd8b46e442fc41c2b86b821562f.png"
    
    var body: some View {
        VStack {
          
            if let imageString = image, let imageURL = URL(string: imageString) {
                
                AsyncImage (
                    url: imageURL,
                    content: { img in
                        img.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                    
                    },
                    placeholder: {
                        ProgressView()
                    }
                )
                                
            } else {
                let placeholderURL = URL(string: DEFAULT)
                
                AsyncImage (
                    url: placeholderURL,
                    content: { img in
                        img.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                    },
                    placeholder: {
                        ProgressView()
                    }
                )
            }
            
            // Artist Information
            Text("\(artist.name.capitalized)")
                .font(.headline)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("LISTENERS")
                        .font(.system(size: 8))
                    Text(LastAPI.formatNumber(number:artist.listeners))
                        .font(.system(size: 11))
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("PLAYCOUNT")
                        .font(.system(size: 8))
                    Text(LastAPI.formatNumber(number:artist.playcount))
                        .font(.system(size: 11))
                }
            }
            
            Button("+ Add to lineup") {
                print("Implement add to lineup here")
            }
            .buttonStyle(.borderedProminent)
            
            
        }.padding()
            .background(Color.clear)
    }
}


#Preview {
    ArtistSearchView(artist: Artist(name: "Radiohead", playcount: "1", listeners: "1", mbid: "XXX", url: "radiohead.com", image: [Image(text: "https://e-cdns-images.dzcdn.net/images/artist/9508c1217e880b52703a525d1bd5250c/250x250-000000-80-0-0.jpg", size: "small")]))
}
