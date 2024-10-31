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

    // Int instead of bool in case we want to add more pages
    @State var page : Int = 0
    @State var searchText : String = ""
    @State var connect : LastAPI = LastAPI()
    @State var isLoading : Bool = true
    @State var artists : [Artist] = []
    // Search result
    @State var results : [Artist] = []
    @State var images : [String:String] = [:]
    
    
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
                            
                            ArtistSearchView(artist: artist, image: images[artist.name])
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
                    // Should be able to search ALL artists
                results = artists.filter { $0.name.lowercased().contains(searchText.lowercased())}
            }
            else {
                results = artists
            }
            
        }
        .onAppear() {
           /* if (isLoading) {
                var data = connect.fetchAllData(limit: 999)
                
                self.artists = data.0
                self.results = data.0
                self.images = data.1
            }*/
            
            if (isLoading) {
                connect.fetchTopArtists(limit: 999) { result in
                    switch result {
                        
                    case .success(let fetchedArtists):
                        print("SUCCESS!")
                        self.isLoading = false
                        for artist in fetchedArtists {
                            print("\(artist.name)")
                            
                            // Try to get image for artist from Deezer API
                            connect.fetchImage(artist: artist.name) { result in
                                switch result {
                                    
                                case .success(let fetchedImages):
                                    print("SUCCESS - images")
                                    self.isLoading = false
                                    
                                    print(artist.name)
                                
                                    // TODO: Better unwrapping
                                    self.images.updateValue((fetchedImages.first?.picture_big)!, forKey: artist.name)
                                    
                                    
                                case .failure (let error):
                                    self.isLoading = false
                                    print("ERROR getting image for \(artist.name): \(error)")
                                }
                                
                            }

                        }
         
                        self.artists = fetchedArtists
                        self.results = fetchedArtists
                        
                    case .failure(let error):
                        self.isLoading = false
                        print("ERROR fetch failure: \(error)")
                        
                    }
                    
                    
                }
            }
        }
    }
    
}
#Preview {
    SearchView()
}
