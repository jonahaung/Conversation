//
//  MsgContextMenu.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct MsgContextMenu: View {
    
    @EnvironmentObject private var msg: Msg
    
    var body: some View {
        Button(action: {
            
        }) {
    
            Label("Hello", systemImage: "circle.fill")
        }
        
        Button(action: {
            
        }) {
            Label("Delete", systemImage: "trash.fill")
        }
    }
}
