//
//  ContentView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var cons = ["aung", "jonah@ibcs.org", "jonahaung@gmail.com", "jonagkomin@gmail.com"]
    var body: some View {
        NavigationView {
            List {
                ForEach(cons, id: \.self) { con in
                    Text(con)
                        .tapToPush(
                            ChatView()
                                .navigationBarHidden(true)
                                .environmentObject(ChatDatasource(conId: con))
                                .environmentObject(RoomProperties(id: con))
                        )
                }
                
                NavigationLink("Settings") {
                    SettingsView()
                }
            }
            .navigationTitle("Home")
        }
        .navigationViewStyle(.stack)
        .environmentObject(CurrentUser.shared)
        .environmentObject(AppUserDefault.shared)
        .environmentObject(OutgoingSocket())
        .environmentObject(IncomingSocket())
    }
}
