//
//  ArtistInfoView.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 10/14/24.
//
import SwiftUI
import FirebaseCore
import FirebaseFirestore

/**
 View to get the description of a music artist from the charts page
 */
struct ArtistInfoView : View {
    // Variables passed in as params
    let name : String
    let image : String?
    let position : Int

    @State var connect : LastAPI = LastAPI()
    @State var isLoading : Bool = true
    @State var artist : ArtistInfo? = nil
    @State var biography : String = ""
   
    let db = Firestore.firestore()
    
    @EnvironmentObject var profileModel : ProfileModel
    @EnvironmentObject var authService : AuthService
    
    
    var body : some View {
        VStack {
            // Show spinning wheel if loading
            if isLoading {
                ProgressView("Loading information for \(name)...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .pink))
            }
            // If not nil
            else if let artist = artist {
                ScrollView() {
                    // Display image
                    if let imageString = image,let imageURL = URL(string: imageString) {
                        
                        AsyncImage (
                            url: imageURL,
                            content: { img in
                                img.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 250, height: 250)
                            
                                    .padding(.top, 10)
                            },
                            placeholder: {
                                ProgressView()
                            }
                        )
                        
                    }
                    
                    // Artist name and position
                    HStack {
                        Text("#\(position)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.pink)
                        Text("\(artist.name.capitalized)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    // Artist info
                    HStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            Text("PLAYCOUNT")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            Text(LastAPI.formatNumber(number: artist.stats.playcount))
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                   
                        Divider()
                            .frame(height: 40)
                            .background(Color.gray.opacity(0.4))
                        
                        VStack(alignment: .leading) {
                            Text("LISTENERS")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            Text(LastAPI.formatNumber(number: artist.stats.listeners))
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 6) {
                        Text("Biography\n")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.pink)
                        
                        // Biography of artist
                        VStack(alignment: .leading) {
                            
                            Text("\(biography)")
                                .font(.body)
                                .foregroundColor(.black)
                        }
                        
                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    
                }
            }
            
            Spacer()
            
            // Add to lineup on press if not there already
            if (!profileModel.lineup.contains(name)){
                Button(action: {
                    profileModel.lineup.append(name)
                    profileModel.addToLineup(artist: name)
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
        }
        .padding()
        .onAppear() {
            // Get current score
            profileModel.fetchScore()
            
            // Get artist information from API
            if (isLoading) {
                connect.fetchArtist(artist: name) { result in
                    switch result {
                        
                    case .success(let fetchedArtist):
                        print("SUCCESS!")
                        self.isLoading = false
                        self.artist = fetchedArtist
                        self.formatBiography()
                        
                    case .failure(let error):
                        self.isLoading = false
                        print("ERROR fetch failure: \(error)")
                        
                    }
                    
                }
                
            }
            
        }
    }
    
    /**
        Last.fm artist biographies contain an href that doesn't register here as a link
        This function removes that link completely from the biography
     */
    private func formatBiography() {
        if let artist = artist {
            let summary = artist.bio.summary
            
            // Check if html in bio
            if summary.contains("<a") {
                if let range = summary.range(of: " <a") {
                    // Store portion before the link
                    let chopped = summary[...range.lowerBound]
                    self.biography = String(chopped)
                }
                
            } else {
                self.biography = summary
            }

        }
        
    }
    
}

#Preview {
    ArtistInfoView(name: "Radiohead", image: "https://e-cdns-images.dzcdn.net/images/artist/9508c1217e880b52703a525d1bd5250c/250x250-000000-80-0-0.jpg", position: 1)
        .environmentObject(AuthService())
        .environmentObject(ProfileModel())
}

