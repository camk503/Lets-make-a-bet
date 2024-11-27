//
//  AuthService.swift
//  MakeABet
//
//  Created by Olivia Alexander on 10/23/24.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class AuthService: ObservableObject {
    
    @Published var signedIn: Bool = false
    @Published var errorDescription : String = ""

    @Published var email : String = ""
    
    private var stateHandle: AuthStateDidChangeListenerHandle?
    private let db = Firestore.firestore()
    
    init() {
        stateHandle = Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.signedIn = true
                print("Auth state changed, is signed in")
            } else {
                self.signedIn = false
                print("Auth state changed, is signed out")
            }
        }
        
        
    }
    
    func createUserDocument(email: String, username: String) {
        Task {
            do {
                try await db.collection("users").document(email).setData(
                    [
                        "email" : email,
                        "username" : username,
                        "lineup" :  ["artist1": "", "artist2" : "", "artist3" : "", "artist4" : "", "artist5" : ""]
                    ],
                    merge: true)
                    
            }
            catch {
                print ("catched create document")
            }
        }
    }
    
    
    // MARK: - Password Account
    func regularCreateAccount(email: String, password: String, username: String) async throws {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.errorDescription = e.localizedDescription
                    print("Error catch create account \(e.localizedDescription)")
                    
                } else {
                    self.errorDescription = ""
                    self.email = email
                    self.createUserDocument(email: email, username: username)
                    print("Successfully created password account")
                    
                }
            }
        }
    
    //MARK: - Traditional sign in
    // Traditional sign in with password and email
    func regularSignIn(email:String, password:String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
            if let e = error {
                completion(e)
            } else {
                print("Login success")
                self.email = email
                completion(nil)
            }
        }
    }
    
    // Regular password acount sign out.
    // Closure has whether sign out was successful or not
    func regularSignOut(completion: @escaping (Error?) -> Void) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            email = ""
            completion(nil)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
          completion(signOutError)
        }
    }
    
}
