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
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State var isLoading : Bool = true
    @State private var currentScore : Float = 0
    @EnvironmentObject var authService: AuthService
    
    private let profileModel = ProfileModel()

    
    var body : some View
    {
        NavigationView() {
            ZStack {
                Color.gray.opacity(0.1).ignoresSafeArea()
                VStack {
                    Text("This is the profile")
                    
                    Text("Username: \(authService.username)")
                    
                    Text("Your Score: \(String(format: "%.0f", currentScore))")
                    
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
        }.onAppear() {
            fetchScore()
        }
    }
    
    private func fetchScore() {
        profileModel.getUserScore { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let score):
                    self.currentScore = score
                case .failure(let error):
                    print("Error loading score: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
