//
//  ChatNavBar.swift
//  Conversation
//
//  Created by Aung Ko Min on 13/2/22.
//

import SwiftUI

struct ChatTopBar: View {
    static let id = 2
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        HStack {
            Button {
                coordinator.con.task()
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .imageScale(.large)
                    .padding()
            }
            HStack {
                AvatarView(id: coordinator.con.id)
                    .frame(width: 35, height: 35)
                    .padding(2)
                    .background(Color.teal)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 0) {
                    Text(coordinator.con.name)
                        .font(.system(size: UIFont.systemFontSize, weight: .bold))
                    Text(Date(), formatter: MsgDateView.dateFormatter)
                        .font(.system(size: UIFont.smallSystemFontSize, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            Button {
                randonMsgs()
            } label: {
                Image(systemName: "circle.fill")
            }
            Image(systemName: "ellipsis")
                .padding()
                .tapToPush(ConSettingsView().environmentObject(coordinator))
        }
        .background(.regularMaterial)
        .saveBounds(viewId: ChatTopBar.id, coordinateSpace: .named("ChatView"))
    }
    
    private func randonMsgs() {
        IncomingSocket.shard.random()
    }
}
