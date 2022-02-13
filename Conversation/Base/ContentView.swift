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
            Form {
                NavigationLink("Go to chat") {
                    ChatView().navigationBarHidden(true)
                        
                }

                NavigationLink("Settings") {
                    SettingsView()
                }
            }
            .navigationTitle("Home")
        }
        .environmentObject(CurrentUser.shared)
        .environmentObject(AppUserDefault.shared)
        .environmentObject(OutgoingSocket())
        .environmentObject(IncomingSocket())
        .navigationViewStyle(.stack)
    }
}
