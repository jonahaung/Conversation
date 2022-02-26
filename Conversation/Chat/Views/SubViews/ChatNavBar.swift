//
//  ChatNavBar.swift
//  Conversation
//
//  Created by Aung Ko Min on 13/2/22.
//

import SwiftUI

struct ChatNavBar: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var chatLayout: ChatLayout
    @EnvironmentObject private var currentUser: CurrentUser
    @EnvironmentObject private var cCon: CCon
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .imageScale(.large)
                        .padding()
                }
                HStack {
                    AvatarView()
                        .frame(width: 35, height: 35)
                        .padding(2)
                        .background(Color.teal)
                        .clipShape(Circle())
                    VStack(alignment: .leading, spacing: 0) {
                        Text(cCon.name!)
                            .font(.system(size: UIFont.systemFontSize, weight: .bold))
                        Text(currentUser.activeDate, formatter: MsgDateView.dateFormatter)
                            .font(.system(size: UIFont.smallSystemFontSize, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                NavigationLink {
                    CConSettingsView()
                        .environmentObject(cCon)
                } label: {
                    Image(systemName: "ellipsis")
                        .padding()
                }
            }
            Divider()
        }
        .background(.ultraThinMaterial)
    }
}
