//
//  ArtistView.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 10/13/24.
//
//  HELPFUL DOCS:
//      Images from URLs: https://wwdcbysundell.com/2021/using-swiftui-async-image/

import SwiftUI

/* How an artist appears on the charts
Shows image, name, rank, playcount, and listeners */
struct ArtistView : View {
    
    // Passed in thru constructor
    let artist : Artist
    let image : String?
    let position : Int
    
    @State var defaultImage : String = "https://lastfm.freetls.fastly.net/i/u/34s/2a96cbd8b46e442fc41c2b86b821562f.png"
    
    var body : some View {
        NavigationLink(destination: ArtistInfoView(name: artist.name, image: image, position: position)) {
            
            // TODO: Function that returns image based on size and artist
            HStack{
                // Image of artist
                //.first? gets first element of array
                Text("\(position)").font(.largeTitle)
        
                if let imageString = image,let imageURL = URL(string: imageString) {
                    
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
                    let placeholderURL = URL(string: defaultImage)
                    
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
                
                /*
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
                */
                // Artist Information
                VStack(alignment: .leading) {
                    Text("\(artist.name.capitalized)")
                        .font(.headline)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("LISTENERS")
                                .font(.system(size: 8))
                            Text(LastAPI.formatNumber(number: artist.listeners))
                                .font(.system(size: 11))
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("PLAYCOUNT")
                                .font(.system(size: 8))
                            Text(LastAPI.formatNumber(number: artist.playcount))
                                .font(.system(size: 11))
                        }
                    }
                    
                }
                
                
            }.padding()

        }
        .buttonStyle(.borderedProminent)
    }
    
    
}
