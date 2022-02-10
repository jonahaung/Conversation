//
//  ContentView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = false
    }
    
    var body: some View {
        NavigationView {
            Form {
                NavigationLink("Go to chat") {
                    ChatView().navigationTitle("Chat")
                        
                }

                NavigationLink("Settings") {
                    SettingsView()
                }
            }
            .navigationTitle("Home")
        }
        .environmentObject(AppUserDefault.shared)
        .navigationViewStyle(.stack)
    }
}
