//
//  ArtistView.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 10/13/24.
//
//  HELPFUL DOCS:
//      Images from URLs: https://wwdcbysundell.com/2021/using-swiftui-async-image/

import SwiftUI

/* How an artist appears on the CHARTS
Shows image, name, rank, playcount, and listeners */
struct ArtistView : View {
    // Passed in thru constructor
    let artist : Artist
    let image : String?
    let position : Int
    let movement : String

    private let DEFAULT : String = "https://lastfm.freetls.fastly.net/i/u/34s/2a96cbd8b46e442fc41c2b86b821562f.png"
    
    var body : some View {
        NavigationLink(destination: ArtistInfoView(name: artist.name, image: image, position: position)) {
            
            HStack(spacing: 15) {
            
                Text("\(position)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.pink)
                    .frame(width: 40, alignment: .center)
        
                if let imageString = image, let imageURL = URL(string: imageString) {
                    AsyncImage (url: imageURL) { img in
                            img.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        
                        }
                        placeholder: {
                            ProgressView()
                        }
                                    
                } else {
                    AsyncImage (url: URL(string: DEFAULT)) { img in
                            img.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        placeholder: {
                            //Text("P")
                            ProgressView()
                        }
                }
                
                // Show icon for movement
                // Need to do SwiftUI.Image bc I defined my own
                // custom struct called Image
                if movement == "up" {
                    SwiftUI.Image(systemName: "chevron.up.circle.fill")
                        .foregroundColor(.green)
                } else if movement == "down" {
                    SwiftUI.Image(systemName: "chevron.down.circle.fill")
                        .foregroundColor(.red)
                } else {
                    SwiftUI.Image(systemName: "chevron.right.circle.fill")
                        .foregroundColor(.gray)
                }
            
                // Artist Information
                VStack(alignment: .leading, spacing: 5) {
                    
                    Text("\(artist.name.capitalized)")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("LISTENERS")
                                .font(.system(size: 8))
                                .foregroundColor(.gray)
                            Text(LastAPI.formatNumber(number: artist.listeners))
                                .font(.system(size: 10))
                        }
                        
                        Divider()
                            .frame(height: 30)
                            .background(Color.gray.opacity(0.4))
                        
                        VStack(alignment: .leading) {
                            Text("PLAYCOUNT")
                                .font(.system(size: 8))
                                .foregroundColor(.gray)
                            Text(LastAPI.formatNumber(number: artist.playcount))
                                .font(.system(size: 10))
                        }
                    }
                    
                }
                SwiftUI.Image(systemName: "chevron.right")
                                    .foregroundColor(.pink)
                
            }//.buttonStyle(PlainButtonStyle())
            .padding(12)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
}
#Preview {
    ArtistView(artist: Artist(name: "Radiohead", playcount: "1", listeners: "1", mbid: "XXX", url: "radiohead.com", image: [Image(text:  "https://e-cdns-images.dzcdn.net/images/artist/9508c1217e880b52703a525d1bd5250c/250x250-000000-80-0-0.jpg", size: "small")]), image: "", position: 1, movement: "up")
}
