//
//  WelcomeView.swift
//  MakeABet
//
//  Created by Olivia Alexander on 10/23/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct WelcomeView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var lineup : [String : String] = ["artist1": "", "artist2" : "", "artist3" : "", "artist4" : "", "artist5" : ""]
    
    @EnvironmentObject var authService: AuthService
    
    let db = Firestore.firestore()
    @State var createError : String = ""
    
    
    func signIn() {
        Task {
            do {
                try await authService.regularCreateAccount(email: email, password: password)
            }
            catch {
                print ("catched failed signin ")
            }
        }
    }
    
    func createAccount() {
        Task {
            do {
                try await authService.regularCreateAccount(email: email, password: password)
                
            }
            catch {
                print ("catched create account ")
            }
        }
    }
    
    func createUserDocument() {
        Task {
            do {
                try await db.collection("users").document(email).setData(
                    [
                        "email" : email,
                        "username" : username,
                        "lineup" : lineup
                    ],
                    merge: true)
                    
            }
            catch {
                print ("catched create document")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.1)
                    .ignoresSafeArea()
                    .opacity(0.5)
                
                VStack {
                    Text("Let's Make A Bet")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                        .padding(.top, 40)
                    Text("Welcome! Let's get started")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .padding(.bottom, 30)
                    
                    // Email and password fields
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        // Red border if error
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(authService.errorDescription.isEmpty ? Color.clear : Color.red, lineWidth: 2)
                        )
                        
                        .shadow(color:.gray.opacity(0.3), radius: 10, x: 0, y: 3)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                    
                    // Username
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        // Red border if error
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(authService.errorDescription.isEmpty ? Color.clear : Color.red, lineWidth: 2)
                        )
                        
                        .shadow(color:.gray.opacity(0.3), radius: 10, x: 0, y: 3)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        // Red border if error
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(authService.errorDescription.isEmpty ? Color.clear : Color.red, lineWidth: 2)
                        )
                        .shadow(color:.gray.opacity(0.3), radius: 10, x: 0, y: 3)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                    
                    if !authService.errorDescription.isEmpty {
                        Text(authService.errorDescription)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.top, 5)
                    }
                    
                    Button("Create Account") {
                        createAccount()
                        createUserDocument()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(.pink)
                    .cornerRadius(10)
                    .padding(.top, 10)
                    
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.gray)
                        
                        NavigationLink(destination: LoginView()) {
                            Text("Login").foregroundColor(.blue)
                        }
                        .navigationBarBackButtonHidden(true) // Hides default back button
                        
                    }.padding(.top, 20)

                }
                .padding(.horizontal, 30)
            }
        }
    }
}

func getErrorDescription() {
    
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView().environmentObject(AuthService())
    }
}
