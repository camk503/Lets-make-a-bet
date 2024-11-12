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
//  Parse JSON:  https://matteomanferdini.com/swift-parse-json/#decodable

import Foundation
import SwiftUI

class LastAPI : ObservableObject {
    private let APIKey : String = "9e1855dd72c6c6933bae914bd3099bd4"
    private let baseURL : String = "https://ws.audioscrobbler.com/2.0/"
    
    @Published var isLoading : Bool /*= true*/
    @Published var isLoadingImage : Bool
    @Published var topArtists : [Artist] /*= []*/
    @Published var allArtists : [Artist] /*= []*/
    @Published var images : [String:String] /*= [:]*/
    
    
    init () {
        self.isLoading = true
        self.isLoadingImage = true
        self.topArtists = []
        self.allArtists = []
        self.images = [:]
    }
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
            //URLQueryItem(name: "page", value: "1")
        ]
        
        // API request
        let session = URLSession.shared // .shared just gives default configs for basic requests
        let url = urlBuilder?.url
        
        // Create a task
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
    
    func fetchArtist(artist: String, completion: @escaping (Result<ArtistInfo, Error>) -> Void) {
        var urlBuilder = URLComponents(string: baseURL)
        
        // Define array of query items (key-val pairs)
        urlBuilder?.queryItems = [
            URLQueryItem(name: "method", value: "artist.getInfo"),
            URLQueryItem(name: "artist", value: artist),
            URLQueryItem(name: "api_key", value: APIKey),
            URLQueryItem(name: "format", value: "json")
            
        ]
        
        // API request
        let session = URLSession.shared // .shared just gives default configs for basic requests
        let url = urlBuilder?.url
        
        let task = session.dataTask(with: url!) { data, response, error in
            
            if let error = error {
                print("Error fetching data for \(artist): \(error)")
                completion(.failure(error))
                return
            }
            
            if let data = data {
                // Attempt to parse JSON data
                // "completion" stores API result
                do {
                    let artistInfo = try JSONDecoder().decode(ArtistInfoResponse.self, from: data)
                    
                    completion(.success(artistInfo.artist))

                } catch {
                    completion(.failure(error))
                    print("Error decoding JSON for artist \(artist): \(error)")
                }

            }
        
        }
        
        task.resume()
        
    }
    
    /* DEEZER IMAGES */
    func fetchImage(artist: String, retries: Int = 3, delay: TimeInterval = 1.0, completion: @escaping (Result<[DeezArtistInfo], Error>) -> Void) {
        let deezerBaseURL : String = "https://api.deezer.com/search/artist"
        var urlBuilder = URLComponents(string: deezerBaseURL)
        urlBuilder?.queryItems = [
            URLQueryItem(name: "q", value: artist)
        ]
        
        // Check if valid URL
        guard let url = urlBuilder?.url else {
            completion(.failure(NSError(domain: "URLBuildingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // API Request
        let session = URLSession.shared
        // let url = urlBuilder?.url
        
        // Create task
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                if retries > 0 {
                    let newDelay = delay * 2
                    print("Error fetching data for \(artist), retrying in \(newDelay) seconds...")
                    
                    // Call function again to retry
                    DispatchQueue.global().asyncAfter(deadline: .now() + newDelay) {
                        self.fetchImage(artist: artist, retries: retries - 1, delay: newDelay, completion: completion)
                    }
                } else {
                    print("Error fetching data for \(artist), no retries left: \(error)")
                    completion(.failure(error))
                }
                return
            }
        
            if let data = data {
                // Attempt to parse JSON data
                // "completion" stores API result
                do {
                    let artistList = try JSONDecoder().decode(DeezArtists.self, from: data)
                    
                    completion(.success(artistList.data))

                } catch {
                    completion(.failure(error))
                    print("Error decoding JSON: \(error)")
                }

            }
        
        }
        task.resume()
    }
    
    
    static func formatNumber(number: String) -> String {
        var formattedNumber : String = ""
        
        if number.count > 3 {
            let reversedNumber : String = String(number.reversed())

            for i in 0..<reversedNumber.count {
                // Get index >:(
                let index = reversedNumber.index(reversedNumber.startIndex, offsetBy: i)
                formattedNumber += String(reversedNumber[index])
                
                if (i + 1).isMultiple(of: 3) && i != (reversedNumber.count - 1) {
                    formattedNumber += ","
                }
            }

            formattedNumber = String(formattedNumber.reversed())
            
        } else {
            formattedNumber = number
        }
        return formattedNumber
        
    }
    func loadData(limit: Int) {
        // Load data only if not already loaded
        if (limit < 999 && topArtists.isEmpty) || (limit > 50 && allArtists.isEmpty) {
            
            self.isLoading = true
            
            self.fetchTopArtists(limit: limit) { result in
                // Wrap UI updates in DispatchQueue
                DispatchQueue.main.async {
                    switch result {
                        
                    case .success(let fetchedArtists):
                        print("SUCCESS!")
                        self.isLoading = false
                 
                        // Set published variables
                        self.allArtists = fetchedArtists
                        self.topArtists = Array(fetchedArtists.prefix(50))
                        
                       
                    case .failure(let error):
                        self.isLoading = false
                        print("ERROR fetch failure: \(error)")
                        
                    }
                }
                
                
            }
        }
    }

}

