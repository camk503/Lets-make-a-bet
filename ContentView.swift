//
//  ContentView.swift
//  PlusMinus
//
//  Created by Olivia Alexander on 9/21/24.
//

import SwiftUI

struct ContentView: View {
    @State private var value = 0
    static var MAXVAL = 5
    
    @State private var color = Color.black
    
    func subtractNum() {
        if value > 0 - ContentView.MAXVAL {
            value = value - 1
        }
        if value < 0 {
            color = Color.red
        }
        else {
            color = Color.black
        }
        
    }
    
    func addNum() {
        if value < ContentView.MAXVAL {
            value = value + 1
        }
        if value < 0 {
            color = Color.red
        }
        else {
            color = Color.black
        }
    }
    
    
    var body: some View {
        VStack (spacing: 50) {
            Text("PlusMinus").font(.largeTitle)
            
            // value and number
            HStack(spacing: 40) {
                Text("value").font(.largeTitle)
                // display changing value
                Text("\(value)").font(.largeTitle).foregroundColor(color)
            }
            //minus and plus buttons
            HStack(spacing: 40) {
                Button("-",action: subtractNum).font(.largeTitle)
                Button("+",action: addNum).font(.largeTitle)
            }
             
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
