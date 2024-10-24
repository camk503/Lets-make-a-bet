//
//  SearchView.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 10/17/24.
//  HELPFUL DOCS:
//      Search: https://developer.apple.com/documentation/swiftui/adding-a-search-interface-to-your-app
//              https://www.appcoda.com/swiftui-searchable/

import SwiftUI

struct SearchView : View {
    /*
     0 = Artists
     1 = Songs
     2 = Profiles
     */
    // Int instead of bool in case we want to add more pages
    @State var page : Int = 0
    @State var searchText : String = ""
    @State var connect : LastAPI = LastAPI()
    @State var isLoading : Bool = true
    @State var artistList : [Artist] = []
    // Search result
    @State var results : [Artist] = []
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button("Search Artists") {
                        page = 0
                    }.buttonStyle(.borderedProminent)
                    Button("Search Profiles") {
                        page = 1
                    }.buttonStyle(.borderedProminent)
                }
                VStack {
                    if page == 0 {
                        // Print current top artists
                        List(results.indices, id: \.self) { index in
                            
                            let artist = results[index]
                            
                            ArtistSearchView(artist: artist)
                        }
                        
                    }
                    else if page == 1 {
                        Text("Put profiles here for search")
                    }
                    
                }
                
            }
        }
        .searchable(text: $searchText)
        .onChange(of: searchText) { searchText in
            if !searchText.isEmpty {
                // TODO: Right now this can only search top 1000 artists
                    // Should be able to search ALL artists
                results = artistList.filter { $0.name.lowercased().contains(searchText.lowercased())}
            }
            else {
                results = artistList
            }
            
        }
        .onAppear() {
            connect.fetchTopArtists(limit: 50) { result in
                switch result {
                    
                case .success(let fetchedArtists):
                    print("SUCCESS!")
                    self.isLoading = false
                    for artist in fetchedArtists {
                        print("\(artist.name)")
                    }
                    
                    self.artistList = fetchedArtists
                    self.results = fetchedArtists
                    
                case .failure(let error):
                    self.isLoading = false
                    print("ERROR fetch failure: \(error)")
                    
                }
                
                
            }
        }
    }
    
}
#Preview {
    SearchView()
}
