//
//  ContentView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            ChatView().navigationTitle("Chat")
        }
        .navigationViewStyle(.stack)
    }
}
