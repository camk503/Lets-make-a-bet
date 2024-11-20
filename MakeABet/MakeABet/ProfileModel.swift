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
            } else if let document = document, document.exists, let data = document.data(), let artists = data["lineup"] as? [String] {
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
                completion?(.failure(NSError(domain: "ProfileModel", code: 400, userInfo: [NSLocalizedDescriptionKey: "Lineup is full"])))
                return
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
}
