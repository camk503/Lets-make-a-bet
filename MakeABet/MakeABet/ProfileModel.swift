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

class ProfileModel {
    private let db = Firestore.firestore()
    
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
    
    
    func getUsername(completion: ((Result< String, Error>) -> Void)? = nil) {
        guard let userEmail = Auth.auth().currentUser?.email else {
            completion?(.failure(NSError(domain: "ProfileModel", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }
        
        db.collection("users").document(userEmail).getDocument { document, error in
            if let error = error {
                completion?(.failure(error))
            } else if let document = document, document.exists, let data = document.data(), let username = data["username"] as? String{
                completion?(.success(username))
            } else {
                completion?(.success(""))
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
                //for artist in lineup grab
                var totalScore : Float = 0
                for artist in lineup {
                    //grab artist score from score document
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
                            
                            //completion?(.success(totalScore))

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
        //for user in users database
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
        //sort userDict largest to smallest
        //userDict = userDict.sorted(by: { $0.value > $1.value})
        //completion?(.success(userDict))

    }
    
}
