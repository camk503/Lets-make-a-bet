//
//  MakeABetApp.swift
//  MakeABet
//
//  Created by Olivia Alexander on 10/10/24.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      
      return true
  }
}
 

@main
struct MakeABetApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var authService = AuthService()
    
    var body: some Scene {
        WindowGroup {
            StartView()
                .environmentObject(authService)
        }
    }
}