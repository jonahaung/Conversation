//
//  ContactCell.swift
//  Conversation
//
//  Created by Aung Ko Min on 7/3/22.
//

import SwiftUI

struct ContactCell: View {
    
    @EnvironmentObject private var contact: CContact
    
    var body: some View {
        HStack {
            if let path = Media.path(userId: contact.id!), let image = UIImage(path: path) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .clipShape(Circle())
            }
            Text(contact.name ?? "Unknown")
                .badge(contact.phoneNumber ?? "")
        }
        .tapToPush(ChatView(contact: contact).navigationBarHidden(true))
    }
}
