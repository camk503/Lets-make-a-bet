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
    // Variables passed in as params
    var artist : Artist
    var image : String?
    var position : Int
    
    @State private var isLoading : Bool = true
    
    private let DEFAULT : String = "https://lastfm.freetls.fastly.net/i/u/34s/2a96cbd8b46e442fc41c2b86b821562f.png"
    
    @EnvironmentObject var profileModel : ProfileModel
    
    var body: some View {
        VStack(alignment: .center) {
            // Display artist image
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
                
            // If no image, show default
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
            // Artist name and position on chart
            HStack(alignment: .center) {
                Text("#\(position)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.pink)
                    .frame(minWidth: 60, alignment: .center)
                
                Text("\(artist.name.capitalized)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            }
            
            // Artist information
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("LISTENERS")
                        .font(.system(size: 8))
                    Text(LastAPI.formatNumber(number:artist.listeners))
                        .font(.system(size: 11))
                }
                Divider()
                    .frame(height: 30)
                    .background(Color.gray.opacity(0.4))
                
                VStack(alignment: .leading) {
                    Text("PLAYCOUNT")
                        .font(.system(size: 8))
                    Text(LastAPI.formatNumber(number:artist.playcount))
                        .font(.system(size: 11))
                }
            }
            
            // Add to lineup if not there already
            if (!profileModel.lineup.contains(artist.name)){
                Button(action: {
                    profileModel.lineup.append(artist.name)
                    profileModel.addToLineup(artist: artist.name)
                    profileModel.getUserScore()
                }) {
                    Text("+ Add to lineup")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.pink)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
            else{
                Button(action: {}) {
                    Text("Already in Your Lineup")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .tint(.black)
                }
                .buttonStyle(.borderedProminent)
                .tint(.gray)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
        }.padding()
            .background(Color.clear)
            .onAppear() {
                profileModel.fetchScore()
            }
    }
  
}

#Preview {
    ArtistSearchView(artist: Artist(name: "Radiohead", playcount: "1", listeners: "1", mbid: "XXX", url: "radiohead.com", image: [Image(text: "https://e-cdns-images.dzcdn.net/images/artist/9508c1217e880b52703a525d1bd5250c/250x250-000000-80-0-0.jpg", size: "small")]), position: 1)
        .environmentObject(ProfileModel())
}
