//
//  LoginView.swift
//  MakeABet
//
//  Created by Olivia Alexander on 10/24/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) var dismiss
    
    @State var loginError : String = ""
    
    var body: some View {
            ZStack {
                Color.gray.opacity(0.1)
                    .ignoresSafeArea()
                
                VStack() {
                    Text("Let's Make A Bet")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                        .padding(.top, 40)
                    
                    // Subtitle and welcome message
                    Text("Login to Existing Account")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .padding(.bottom, 30)
                    
                    // Prompt for user account info (email and password)
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        // Red border if error
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(loginError.isEmpty ? Color.clear : Color.red, lineWidth: 2)
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
                                .stroke(loginError.isEmpty ? Color.clear : Color.red, lineWidth: 2)
                        )
                        .shadow(color:.gray.opacity(0.3), radius: 10, x: 0, y: 3)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
            
                    // Display error message if there is one
                    if !loginError.isEmpty {
                        Text(loginError)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.top, 5)
                    }

                    // Button logs user in or throws error
                    Button("Login") {
                        authService.regularSignIn(email: email, password: password) { error in
                            if let e = error {
                                print(e.localizedDescription)
                                loginError = "Incorrect email or password. Please try again."
                            } else {
                                loginError = ""
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.pink)
                    .controlSize(.large)
                    .cornerRadius(10)
                    .padding(.top, 10)
                    
                    // Direct to create account page if new user
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.gray)
                        
                        Button {
                            dismiss()
                        } label: {
                            Text("Create Account").foregroundColor(.blue)
                        }
                    }.padding(.top, 20)

                }
                .padding(.horizontal, 30)
                
            }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LoginView()
}
