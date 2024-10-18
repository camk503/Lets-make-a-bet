//
//  ArtistSearchView.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 10/17/24.
//

// How artists appear on the search page
// Sorry about all these artist views ... awk

import SwiftUI

struct ArtistSearchView: View {
    var artist : Artist
    var body: some View {
        VStack {
            // Image of artist
            //.first? gets first element of array
            // Text("\(position)").font(.largeTitle)
            
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
            
            Button("+ Add to lineup") {
                print("Implement add to lineup here")
            }
            .buttonStyle(.borderedProminent)
            
            
        }.padding()
            .background(Color.clear)
    }
}


