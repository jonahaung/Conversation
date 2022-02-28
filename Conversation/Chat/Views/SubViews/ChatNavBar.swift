//
//  ChatNavBar.swift
//  Conversation
//
//  Created by Aung Ko Min on 13/2/22.
//

import SwiftUI

struct ChatNavBar: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var currentUser: CurrentUser
    @EnvironmentObject private var coordinator: Coordinator
    
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
                        Text(coordinator.con.name)
                            .font(.system(size: UIFont.systemFontSize, weight: .bold))
                        Text(currentUser.activeDate, formatter: MsgDateView.dateFormatter)
                            .font(.system(size: UIFont.smallSystemFontSize, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "ellipsis")
                    .padding()
                    .tapToPush(ConSettingsView().environmentObject(coordinator))
            }
            Divider()
        }
        .background(.ultraThinMaterial)
    }
}
