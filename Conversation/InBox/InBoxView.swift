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
        List {
            Section {
                ForEach(manager.cCons) {
                    InBoxCell()
                        .environmentObject($0)
                }
                .onDelete(perform: delete(at:))
            }
        }
        .listStyle(.plain)
        .refreshable{
            manager.refresh()
        }
        .onAppear(perform: manager.onAppear)
        .navigationTitle("Inbox")
        .navigationBarItems(leading: navLeading, trailing: navTrailing)
    }
}

extension InBoxView {
    
    private var navLeading: some View {
        Text("Settings").tapToPush(SettingsView())
    }
    
    private var navTrailing: some View {
        Button {
            CCon.create(id: UUID().uuidString)
            manager.update()
        } label: {
            Image(systemName: "plus")
        }
    }
    
    func delete(at offsets: IndexSet) {
        if let first = offsets.first {
            CCon.delete(cCon: manager.cCons[first])
            manager.cCons.remove(atOffsets: offsets)
        }
    }
}
