//
//  ProfileModel.swift
//  MakeABet
//
//  Created by Nathaniel Smith on 11/4/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

let MAX_NUM_ARTISTS = 10

/**
 Facilitates in adding artists to lineup and storing lineups for each user
 */
class ProfileModel : ObservableObject {
    private let db = Firestore.firestore()

    // Variables to hold user score and lineup
    // Can be seen by all views
    @Published var isLoading : Bool
    @Published var currentScore : Float
    @Published var lineup : [String]
    
    init() {
        self.isLoading = true
        self.currentScore = 0
        self.lineup = []
        
        self.fetchScore()
        self.fetchLineup()
    }
    
    func setLineup(artists: [String], completion: ((Result<Void, Error>) -> Void)? = nil) {
        guard let userEmail = Auth.auth().currentUser?.email else {
            completion?(.failure(NSError(domain: "ProfileModel", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }
        
        let lineupData: [String: Any] = ["lineup": artists]
        
        db.collection("users").document(userEmail).setData(lineupData, merge: true) { error in
            if let error = error {
                completion?(.failure(error))
            } else {
                completion?(.success(()))
            }
        }
    }
    
    func getLineup(completion: ((Result<[String], Error>) -> Void)? = nil) {
        guard let userEmail = Auth.auth().currentUser?.email else {
            completion?(.failure(NSError(domain: "ProfileModel", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }
        
        db.collection("users").document(userEmail).getDocument { document, error in
            if let error = error {
                completion?(.failure(error))
            } else if let document = document, document.exists, let data = document.data(), let artists = data["lineup"] as? [String]{
                completion?(.success(artists))
            } else {
                completion?(.success([]))
            }
        }
    }
    
    func addToLineup(artist: String, completion: ((Result<Void, Error>) -> Void)? = nil) {
        guard let userEmail = Auth.auth().currentUser?.email else {
            completion?(.failure(NSError(domain: "ProfileModel", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }
        
        let userDocumentRef = db.collection("users").document(userEmail)
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let userDocument: DocumentSnapshot
            do {
                userDocument = try transaction.getDocument(userDocumentRef)
            } catch let error as NSError {
                errorPointer?.pointee = error
                return nil
            }
            
            var artists = userDocument.data()?["lineup"] as? [String] ?? []
            
            if artists.count >= MAX_NUM_ARTISTS {
                artists.removeFirst()
                /**
                completion?(.failure(NSError(domain: "ProfileModel", code: 400, userInfo: [NSLocalizedDescriptionKey: "Lineup is full"])))
                return
                 */
            }
            
            if !artists.contains(artist) {
                artists.append(artist)
                transaction.updateData(["lineup": artists], forDocument: userDocumentRef)
            }

            
            return nil
        }) { (object, error) in
            if let error = error {
                completion?(.failure(error))
            } else {
                completion?(.success(()))
            }
        }
    }
    
    
    func getUserScore(completion: ((Result< Float, Error>) -> Void)? = nil) {
        guard let userEmail = Auth.auth().currentUser?.email else {
            completion?(.failure(NSError(domain: "ProfileModel", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }
        
        db.collection("users").document(userEmail).getDocument { document, error in
            if let error = error {
                completion?(.failure(error))
            } else if let document = document, document.exists, let data = document.data(), let lineup = data["lineup"] as? [String]{
                // for artist in lineup grab
                var totalScore : Float = 0
                for artist in lineup {
                    // grab artist score from score document
                    self.db.collection("scores").document(artist).getDocument() { scoreDoc, error in
                        if let error = error {
                            completion?(.failure(error))
                        } else if let document = scoreDoc, document.exists, let scoreData = document.data(), let artistScore = scoreData["score"] as? Float {
                            totalScore = totalScore + artistScore
                            
                            let scoreData: [String: Float] = ["score": totalScore]
                            
                            self.db.collection("users").document(userEmail).setData(scoreData, merge: true) { error in
                                if let error = error {
                                    completion?(.failure(error))
                                } else {
                                    completion?(.success(totalScore))
                                }
                            }

                        } else {
                            completion?(.success(0))
                        }
                    }
                }
                //completion?(.success(totalScore))
            } else {
                completion?(.success(0))
            }
        }
        
        
    }
    
    func getTopUsers(completion: ((Result< Dictionary<String, Float>, Error>) -> Void)? = nil) {
        var userDict: [String: Float] = [:]
        // for user in users database
        var username : String = ""
        var score : Float = 0
        
        db.collection("users").whereField ("score", isNotEqualTo: false).order(by: "score", descending: true).getDocuments() {(querySnapshot, error) in
            if let error = error{
                completion?(.failure(error))
            } else {
                for document in querySnapshot!.documents {
                    username = document.get("username") as! String
                    score = document.get("score") as! Float
                    userDict.updateValue(score, forKey: username)
                    //userDict.updateValue(score, forKey: username)
                }
                completion?(.success(userDict))

            }
        }

    }
    
    // Function to avoid duplicate code
    // Gets user score and stores in published variable
    func fetchScore() {
        getUserScore() { result in
            DispatchQueue.main.async {
                self.isLoading = true
                switch result {
                case .success(let score):
                    self.currentScore = score
                    self.isLoading = false
                case .failure(let error):
                    print("Error loading score: \(error.localizedDescription)")
                    self.isLoading = false
                }
            }
        }
    }
    
    // Function to avoid duplicate code
    // Gets user lineup and stores in published variable
    func fetchLineup() {
        getLineup() { result in
            DispatchQueue.main.async {
                self.isLoading = true
                switch result {
                case .success(let artists):
                    self.lineup = artists
                    self.isLoading = false
                case .failure(let error):
                    print("Error loading lineup: \(error.localizedDescription)")
                    self.isLoading = false
                }
            }
        }
    
    }
    
}
