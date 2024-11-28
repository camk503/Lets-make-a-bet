//
//  ProfileView.swift
//  MakeABet
//
//  Created by Olivia Alexander on 10/17/24.
//
// HELPFUL DOCS
// Store info with Firebase: https://firebase.google.com/docs/reference/swift/firebaseauth/api/reference/Classes/AdditionalUserInfo#/c:objc(cs)FIRAdditionalUserInfo(py)newUser
// Adding Firebase to Project: https://firebase.google.com/docs/ios/setup


import SwiftUI
import FirebaseCore
import FirebaseFirestore

/**
 Displays the user's profile information
 */
struct ProfileView : View {
    var preferNotifications = true
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var profileModel : ProfileModel
    
    var body : some View
    {
            ZStack {
                Color.gray.opacity(0.1).ignoresSafeArea()
               
                VStack {
                    Text("Profile")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                        .foregroundColor(.pink)
                    
                    // Classic profile image
                    SwiftUI.Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                    
                    // Display username
                    Text("\(authService.username.isEmpty ? "Loading username..." : authService.username)")
                        .fontWeight(.semibold)
                        .font(.system(size: 20))
                        .foregroundColor(.pink)
                    
                    // Display current score
                    Text("Your Score: \(String(format: "%.0f", profileModel.currentScore))")
                        .fontWeight(.semibold)
                        .font(.subheadline)
                    
                    // Button directs back to welcome page
                    Button("Log out") {
                        print("Log out tapped!")
                        authService.regularSignOut { error in
                            
                            if let e = error {
                                print(e.localizedDescription)
                            }
                        }
                    }
                
                }.navigationTitle("Profile")
                   
            }
            .onAppear() {
                profileModel.fetchScore()
            }
    }
}

#Preview {
    ProfileView().environmentObject(AuthService())
        .environmentObject(ProfileModel())
}
