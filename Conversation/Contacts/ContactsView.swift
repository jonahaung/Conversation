//
//  ContactsView.swift
//  Conversation
//
//  Created by Aung Ko Min on 7/3/22.
//

import SwiftUI

struct ContactsView: View {
    
    @StateObject private var manager = ContactManager()
    
    var body: some View {
        VStack {
            List {
                ForEach(manager.displayContacts) { contact in
                    ContactCell()
                        .environmentObject(contact)
                }
                .onDelete(perform: manager.delete(at:))
            }
        }
        .navigationTitle("Contacts")
        .task {
            manager.task()
        }
        .searchable(text: $manager.searchText)
    }
}
