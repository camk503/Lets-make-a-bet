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

/**
 This class facilitates user login and account creation
 */
class AuthService: ObservableObject {
    
    @Published var signedIn: Bool = false
    @Published var errorDescription : String = ""

    @Published var email : String = ""
    @Published var username : String = ""
    @Published var lineup : [String : String] = [:]
    
    private var stateHandle: AuthStateDidChangeListenerHandle?
    private let db = Firestore.firestore()
    
    init() {
        stateHandle = Auth.auth().addStateDidChangeListener() { auth, user in
            if let user = user {
                self.signedIn = true
                self.email = user.email ?? ""
                
                Task {
                    await self.loadUserDocument()
                }
                print("Auth state changed, is signed in")
            
            } else {
                self.signedIn = false
                print("Auth state changed, is signed out")
            }
        }
        
        
    }
    
    /**
     Create a document in the "users" chart on FB containing user information
     Contains email, username, and lineup
     */
    func createUserDocument(email: String, username: String) async {
        Task {
            do {
                try await db.collection("users").document(email).setData(
                    [
                        "email" : email,
                        "username" : username,
                        "lineup" :  ["artist1": "", "artist2" : "", "artist3" : "", "artist4" : "", "artist5" : ""]
                    ],
                    merge: true)
                
                print("User document created for \(self.email)")
                    
            }
            catch {
                print ("catched create document")
            }
        }
    }
    
    /**
        Retrieves an existing user document from firebase by email
     */
    func loadUserDocument() async {
        guard !email.isEmpty else {
            print("Error: email is empty, cannot load user document")
            return
        }
        
        let docRef = db.collection("users").document(self.email)
        do
        {
            let doc = try await docRef.getDocument()
            if let data = doc.data() {
                DispatchQueue.main.async {
                    self.username = data["username"] as? String ?? ""
                    self.lineup = data["lineup"] as? [String : String] ?? [:]
                }
                print("User document loaded: \(data)")
            }
            else
            {
                print("No user document found for \(email)")
            }
        }
        catch
        {
            print("Could not load user data")
        }
    }
    
    // MARK: - Password Account
    /**
     Creates new account with email, password, and username
     */
    func regularCreateAccount(email: String, password: String, username: String) async throws {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.errorDescription = e.localizedDescription
                    print("Error catch create account \(e.localizedDescription)")
                    
                } else {
                    self.errorDescription = ""
                    self.email = email
                    self.username = username
                    Task {
                        await self.createUserDocument(email: email, username: username)
                    }
                    
                    print("Successfully created password account")
                    
                }
            }
        }
    
    // MARK: - Traditional sign in
    /**
     Traditional sign in using password and email
     */
    func regularSignIn(email:String, password:String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
            if let e = error {
                completion(e)
            } else {
                print("Login success")
                self.email = email
                Task
                {
                    await self.loadUserDocument()
                }
                completion(nil)
            }
        }
    }
    
    /**
     Regular password acount sign out.
     Closure has whether sign out was successful or not
     */
    func regularSignOut(completion: @escaping (Error?) -> Void) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            email = ""
            username = ""
            completion(nil)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
          completion(signOutError)
        }
    }
    
    
}

