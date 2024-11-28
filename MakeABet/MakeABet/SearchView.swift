//
//  SearchView.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 10/17/24.
//  HELPFUL DOCS:
//      Search: https://developer.apple.com/documentation/swiftui/adding-a-search-interface-to-your-app
//              https://www.appcoda.com/swiftui-searchable/

import SwiftUI

/**
 View allows user to search the top 999 artists
 */
struct SearchView : View {
    @State var searchText : String = ""
    @EnvironmentObject var connect : LastAPI /*= LastAPI()*/
    
    // Search result
    @State var results : [Artist] = []
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    if (connect.isLoading) {
                        ProgressView("Loading all artists...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .pink))
                    } else {
                        // Print current top artists
                        if !connect.topArtists.isEmpty || !connect.allArtists.isEmpty {
                            ScrollView() {
                                LazyVStack(alignment: .center) {
                                    ForEach(results.indices, id: \.self) { index in
                                        
                                        let artist = results[index]
                                        
                                        // Get position in all artists array
                                        if let allArtistsIndex = connect.allArtists.firstIndex(where: { $0.name == artist.name }) {
                                            // Pass the position in the allArtists array to ArtistSearchView
                                            ArtistSearchView(artist: artist, image: connect.images[artist.name], position: allArtistsIndex + 1)
                                                .onAppear() {
                                                    // Load images as the artist appears
                                                    if connect.images[artist.name] == nil {
                                                        connect.fetchImage(artist: artist.name) { result in
                                                            switch result {
                                                            case .success(let images):
                                                                connect.images[artist.name] = images.first?.picture_big
                                                            case .failure(let error):
                                                                print("Error loading image for \(artist.name): \(error)")
                                                            }
                                                        }
                                                    }
                                                }
                                        }
                                        Divider()
                                            .frame(maxWidth: .infinity, maxHeight: 4)
                                            .background(Color.gray.opacity(0.4))
                                    }
                                    
                                }
                            }.padding()
                                .background(Color.white.opacity(0.95))
                                .cornerRadius(10)
                        }
                    }
                    
                }.padding()
                
            }.background(Color.gray.opacity(0.1))
                
        }
        .searchable(text: $searchText)
        .onChange(of: searchText) { searchText in
            // Change results array as search text changes
            if !searchText.isEmpty {
                // Should be able to search ALL artists
                results = connect.allArtists.filter { $0.name.lowercased().contains(searchText.lowercased())
                }
            }
            // If nothing in search display top 50 artists
            else {
                results = connect.topArtists
            }
            
        }
        .onReceive(connect.$topArtists) { newArtists in
            if searchText.isEmpty {
                results = newArtists
            }
        }
        .onReceive(connect.$allArtists) { newArtists in
            if !searchText.isEmpty {
                results = newArtists.filter {
                    $0.name.lowercased().contains(searchText.lowercased())
                }
            }
        }

    }
    
}
#Preview {
    SearchView().environmentObject(LastAPI())
}
