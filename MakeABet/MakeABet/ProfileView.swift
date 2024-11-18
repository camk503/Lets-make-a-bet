//
//  ProfileView.swift
//  MakeABet
//
//  Created by Olivia Alexander on 10/17/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct ProfileView : View {
    var preferNotifications = true
    
    @EnvironmentObject var authService: AuthService
        
    
    var body : some View
    {
        NavigationView() {
            ZStack {
                Color.gray.opacity(0.1).ignoresSafeArea()
                VStack {
                    Text("This is the profile")
                    
                    Text("Username: \(authService.username)")
                    
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
}

#Preview {
    ProfileView()
}
