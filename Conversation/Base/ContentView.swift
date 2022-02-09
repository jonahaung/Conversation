//
//  ContentView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct ContentView: View {
    
    init() {
//        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    var body: some View {
        NavigationView {
            ChatView().navigationTitle("Chat")
                .environmentObject(ChatDatasource())
                .environmentObject(ChatLayout())
                .environmentObject(MsgCreator())
                .environmentObject(MsgSender())
                .environmentObject(ChatInputViewManager())
                .environmentObject(ChatActionHandler())
        }
        .navigationViewStyle(.stack)
    }
}
