//
//  ContentView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct InBoxView: View {
    
    @StateObject private var manager = InBoxManager()
    
    var body: some View {
        VStack {
            List {
                ForEach(manager.cons) {
                    InBoxCell(con: $0)
                }
                .onDelete(perform: delete(at:))
            }
            .listStyle(.plain)
            .refreshable{
                manager.refresh()
            }
            .task {
                manager.task()
            }
            bottomBar
        }
        .navigationTitle("Inbox")
        .navigationBarItems(trailing: EditButton())
    }
    
    private var bottomBar: some View {
        HStack {
            Text("Contacts")
                .tapToPush(ContactsView())
            Spacer()
            Text("Settings").tapToPush(SettingsView())
        }.padding(.horizontal)
    }
}

extension InBoxView {
    func delete(at offsets: IndexSet) {
        if let first = offsets.first {
            let con =  manager.cons[first]
            if let cCon = CCon.cCon(for: con.id) {
                CCon.delete(cCon: cCon)
                manager.task()
            }
        }
    }
}
