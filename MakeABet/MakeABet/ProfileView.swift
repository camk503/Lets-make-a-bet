//
//  ProfileView.swift
//  MakeABet
//
//  Created by Olivia Alexander on 10/17/24.
//

import SwiftUI
import FirebaseCore

struct ProfileView : View {
    var username : String = ""
    var preferNotifications = true
    
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject var authService: AuthService
    
    var body : some View {
        NavigationView() {
            VStack {
                Text("This is the profile")
                
                Text("Username: ")
                
                Button("Log out") {
                    print("Log out tapped!")
                    authService.regularSignOut { error in
                        
                        if let e = error {
                            print(e.localizedDescription)
                        }
                    }
                }
                
                //Store info with Firebase
                //https://firebase.google.com/docs/reference/swift/firebaseauth/api/reference/Classes/AdditionalUserInfo#/c:objc(cs)FIRAdditionalUserInfo(py)newUser
                //Adding Firebase to Project
                // https://firebase.google.com/docs/ios/setup
                
            }.navigationTitle("Profile")
        }
    }
}


