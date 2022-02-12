//
//  ChatNavBar.swift
//  Conversation
//
//  Created by Aung Ko Min on 13/2/22.
//

import SwiftUI

struct ChatNavBar: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var roomProperties: RoomProperties
    
    var body: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .padding()
            }
            
            HStack {
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: (30), height: 30)
                    .foregroundStyle(.tertiary)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Aung Ko Min")
                        .font(.system(size: UIFont.systemFontSize, weight: .bold))
                    
                    Text("1 hr ago")
                        .font(.system(size: UIFont.smallSystemFontSize, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            NavigationLink {
                RoomPropertiesView()
                    .environmentObject(roomProperties)
            } label: {
                Image(systemName: "ellipsis")
                    .padding()
            }
        }
        .background(.ultraThinMaterial)
    }
}
