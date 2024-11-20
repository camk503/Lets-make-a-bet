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
    @State private var lineup : [String] = []
    @State private var isLoading : Bool = true
    var artist : Artist
    var image : String?
    var position : Int
    
    private let DEFAULT : String = "https://lastfm.freetls.fastly.net/i/u/34s/2a96cbd8b46e442fc41c2b86b821562f.png"
    private let profileModel = ProfileModel()
    
    var body: some View {
        VStack(alignment: .center) {
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
            HStack(alignment: .center) {
                Text("#\(position)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.pink)
                    .frame(minWidth: 60, alignment: .center)
                
                // Artist Information
                Text("\(artist.name.capitalized)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            }
            
            HStack(spacing: 20) {
                // Text("#\(position)")
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
            
            if (!lineup.contains(artist.name)){
                Button(action: {
                    lineup.append(artist.name)
                    profileModel.addToLineup(artist: artist.name)
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
                fetchLineup()
            }
    }
    
    private func fetchLineup() {
        profileModel.getLineup { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let artists):
                    self.lineup = artists
                case .failure(let error):
                    print("Error loading lineup: \(error.localizedDescription)")
                }
            }
        }
    }
}


#Preview {
    ArtistSearchView(artist: Artist(name: "Radiohead", playcount: "1", listeners: "1", mbid: "XXX", url: "radiohead.com", image: [Image(text: "https://e-cdns-images.dzcdn.net/images/artist/9508c1217e880b52703a525d1bd5250c/250x250-000000-80-0-0.jpg", size: "small")]), position: 1)
}
