//
//  ProfileModel.swift
//  MakeABet
//
//  Created by Nathaniel Smith on 11/4/24.
//

import Foundation
import Firebase
import FirebaseAuth
//import Firestore

class ProfileModel {
    private let db = Firestore.firestore()

    // Function to set the lineup (list of musical artists) for the logged-in user
    func setLineup(artists: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "ProfileModel", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }

        let lineupData: [String: Any] = ["artists": artists]

        db.collection("users").document(userId).setData(lineupData, merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // Function to get the lineup (list of musical artists) for the logged-in user
    func getLineup(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "ProfileModel", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }

        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists, let data = document.data(), let artists = data["artists"] as? [String] {
                completion(.success(artists))
            } else {
                completion(.success([])) // Return an empty array if no artists found
            }
        }
    }

    // Function to add a single artist to the lineup for the logged-in user
    func addToLineup(artist: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "ProfileModel", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }

        let userDocumentRef = db.collection("users").document(userId)

        // Use a transaction to safely read and update the artists list
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let userDocument: DocumentSnapshot
            do {
                userDocument = try transaction.getDocument(userDocumentRef)
            } catch let error as NSError {
                errorPointer?.pointee = error
                return nil
            }

            // Get the current list of artists
            var artists = userDocument.data()?["artists"] as? [String] ?? []

            // Add the new artist if it’s not already in the list
            if !artists.contains(artist) {
                artists.append(artist)
                transaction.updateData(["artists": artists], forDocument: userDocumentRef)
            }

            return nil
        }) { (object, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
