//
//  ContentView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var datasource = ChatDatasource()
    
    var body: some View {
        NavigationView {
            ChatView()
                .environmentObject(datasource)
                .navigationTitle("Chat")
                .task {
                    datasource.msgHandler = ChatActions(onSendMessage: { msg in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            msg.applyAction(action: .MsgProgress(value: .Sent))
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                msg.applyAction(action: .MsgProgress(value: .Received))
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    msg.applyAction(action: .MsgProgress(value: .Read))
                                }
                            }
                        }
                    }, onTapMessage: { msg in
                        
                    })
                }
        }
        .navigationViewStyle(.stack)
    }
    
    
}
