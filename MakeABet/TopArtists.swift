//
//  TopArtists.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 10/11/24.
//


//
//  LastFmAPI.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 10/11/24.
//
// HELPFUL DOCS:
//  API: https://www.last.fm/api/show/chart.getTopArtists // Get global top artist charts
//  URL Builder: https://developer.apple.com/documentation/foundation/urlcomponents // Build URL
//               https://developer.apple.com/documentation/foundation/urlcomponents/1779966-queryitems // Build URL
//               https://developer.apple.com/documentation/foundation/urlsession // Make API request
//               https://developer.apple.com/documentation/foundation/urlsession/1407613-datatask // Gets contents of URL
//  Parse JSON: https://matteomanferdini.com/swift-parse-json/#decodable


import Foundation

// For parsing JSON
struct TopArtists : Decodable  {
    let artists : [Artist]
}

// Nested Artist info
struct Artist : Decodable {
    let name : String
    let playcount : String
    let listeners : String
    let mbid : String
    let url : String
    let image : [Image]
}

// Nested Info
struct Image : Decodable {
    let text : String
    let size : String
}

struct LastAPI {
    private let APIKey : String = "9e1855dd72c6c6933bae914bd3099bd4"
    private let baseURL : String = "https://ws.audioscrobbler.com/2.0/"
    
    
    // TODO: Implement completion handler
    func fetchTopArtists(limit: Int) -> Bool {
        if (limit < 1 || limit > 1000) {
            print("Limit must be between 1-1000")
            return false
        }
        
        let method : String = "chart.getTopArtists"
        let format : String = "json"
        var urlBuilder = URLComponents(string: baseURL)
        
        // Define array of query items (key-val pairs)
        urlBuilder?.queryItems = [
            URLQueryItem(name: "method", value: method),
            URLQueryItem(name: "api_key", value: APIKey),
            URLQueryItem(name: "format", value: format),
            URLQueryItem(name: "limit", value: String(limit))
        ]
        
        // API request
        let session = URLSession.shared // .shared just gives default configs for basic requests
        let url = urlBuilder?.url
        
        // Create a task? Im not sure hwat im dpoing
        let task = session.dataTask(with: url!) { data, response, error in
            
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                        print(jsonString)
                }
            }
            
            
            // Parse JSON
            // TODO: Error handling (do catch)
            //let topArtists = try JSONDecoder().decode(TopArtists.self, from: json)
            
        }.resume()
    
        return true
    }
}
