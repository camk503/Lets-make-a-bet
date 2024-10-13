//  LastAPI.swift
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
    //let artists : [Artist]
    let artists : ArtistList
}

// Struct to represent JSON data
struct ArtistList : Decodable {
    let artist : [Artist]
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

// Nested Nested Image Info
struct Image : Decodable {
    let text : String
    let size : String
    
    // Text labelled as "#text"
    private enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size
    }
}

struct LastAPI {
    private let APIKey : String = "9e1855dd72c6c6933bae914bd3099bd4"
    private let baseURL : String = "https://ws.audioscrobbler.com/2.0/"
    
   
    /**
        This function gets the current top artists for the week from Last.fm's API
     */
    func fetchTopArtists(limit: Int, completion: @escaping (Result<[Artist], Error>) -> Void) {
        if (limit < 1 || limit > 1000) {
            print("Limit must be between 1-1000")
            return
        }

        var urlBuilder = URLComponents(string: baseURL)
        
        // Define array of query items (key-val pairs)
        urlBuilder?.queryItems = [
            URLQueryItem(name: "method", value: "chart.getTopArtists"),
            URLQueryItem(name: "api_key", value: APIKey),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "limit", value: String(limit))
        ]
        
        // API request
        let session = URLSession.shared // .shared just gives default configs for basic requests
        let url = urlBuilder?.url
        
        // Create a task? (see docs I dont really understand this)
        let task = session.dataTask(with: url!) { data, response, error in
            
            if let error = error {
                print("Error fetching data: \(error)")
                completion(.failure(error))
                return
            }
            
            if let data = data {
                // Attempt to parse JSON data
                // "completion" stores API result
                do {
                    let topArtists = try JSONDecoder().decode(TopArtists.self, from: data)
                    
                    completion(.success(topArtists.artists.artist))

                } catch {
                    completion(.failure(error))
                    print("Error decoding JSON: \(error)")
                }

            }
        
        }
        task.resume()

    }
}

