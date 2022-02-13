//
//  SettingsView.swift
//  Conversation
//
//  Created by Aung Ko Min on 9/2/22.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject private var appUserDefault: AppUserDefault
    
    var body: some View {
        Form {
            Toggle("Auto Generate Msgs", isOn: $appUserDefault.autoGenerateMockMessages)
            Stepper("Cell Spacing \(Int(appUserDefault.chatCellSpacing))", value: $appUserDefault.chatCellSpacing, in: 0...10)
            Toggle("Cell Draggable", isOn: $appUserDefault.canDragCell)
        }
        .navigationTitle("Settings")
    }
}
