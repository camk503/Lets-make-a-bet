//
//  HomeView.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 11/12/24.
//
import SwiftUI

struct HomeView : View {
    var body : some View {
        NavigationView() {
            VStack {
                Text("Home")
                    .font(.largeTitle)
                
                Text("On this page:\n1. Edit Lineup")
                
            }.navigationTitle("Home")
                .background(Color.gray.opacity(0.1))
        }
    }
}
#Preview {
    HomeView()
}
