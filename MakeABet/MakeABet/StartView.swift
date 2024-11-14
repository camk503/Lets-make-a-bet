//
//  StartView.swift
//  MakeABet
//
//  Created by Olivia Alexander on 10/23/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
//import FirebaseAuth

struct StartView: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
            if authService.signedIn {
                ContentView().environmentObject(LastAPI())
                    .environmentObject(FirebaseManager())
            } else {
                WelcomeView()
            }
    }
}

#Preview {
    StartView().environmentObject(AuthService())
}
