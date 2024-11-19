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
            ContentView()
        } else {
            WelcomeView()
        }
    }
}

struct StartView_Previews: PreviewProvider {
    @StateObject static var authService = AuthService()

    static var previews: some View {
        if authService.signedIn {
            ContentView().environmentObject(authService)
        } else {
            WelcomeView().environmentObject(authService)
        }
    }
}


