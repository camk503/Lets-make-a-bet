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
        //NavigationView {
            ZStack {
                Color.gray.opacity(0.1)
                    .ignoresSafeArea()
                
                VStack() {
                    // Spacer()
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
                    
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.gray)
                        
                        Button {
                            dismiss()
                        } label: {
                            Text("Create Account").foregroundColor(.blue)
                        }
                    }.padding(.top, 20)
                    
                    //Spacer()
                }
                .padding(.horizontal, 30)
                
            }.navigationBarBackButtonHidden(true)
        //}
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
