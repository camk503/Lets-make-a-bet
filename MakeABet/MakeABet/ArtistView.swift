//
//  ArtistView.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 10/13/24.
//
// HELPFUL DOCS:
//  Images from URLs: https://wwdcbysundell.com/2021/using-swiftui-async-image/

import SwiftUI

/* How an artist appears on the charts
Shows image, name, rank, playcount, and listeners */
struct ArtistView : View {
    
    // Passed in thru constructor
    let artist : Artist
    let position : Int
    
    var body : some View {
        NavigationLink(destination: ArtistInfoView(name: artist.name, position: position)) {
            
            HStack{
                // Image of artist
                //.first? gets first element of array
                Text("\(position)").font(.largeTitle)
                
                if let smallImage = artist.image.first?.text, let imageURL = URL(string: smallImage) {
                    AsyncImage(
                        url: imageURL,
                        content: { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                        },
                        placeholder: {
                            ProgressView()
                        }
                    )
                }
                
                // Artist Information
                VStack(alignment: .leading) {
                    Text("\(artist.name.capitalized)")
                        .font(.headline)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("LISTENERS")
                                .font(.system(size: 8))
                            Text("\(artist.listeners)")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("PLAYCOUNT")
                                .font(.system(size: 8))
                            Text("\(artist.playcount)")
                                .font(.subheadline)
                        }
                    }
                    
                }
                
                
            }.padding()
                .background(Color.clear)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    
}
