//
//  MsgContextMenu.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct MsgContextMenu: View {
    
    @EnvironmentObject private var msg: Msg
    @EnvironmentObject private var datasource: ChatDatasource
    
    var body: some View {
        Button(action: {
            
        }) {
    
            Label("Hello", systemImage: "circle.fill")
        }
        
        Button(action: {
            if let index = datasource.msgs.firstIndex(of: msg) {
                datasource.msgs.remove(at: index)
            }
        }) {
            Label("Delete", systemImage: "trash.fill")
        }
    }
}
