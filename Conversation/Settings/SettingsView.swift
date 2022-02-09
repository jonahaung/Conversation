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
            Toggle("Show time labels", isOn: $appUserDefault.showTimeLabels)
            Toggle("Auto Generate Msgs", isOn: $appUserDefault.autoGenerateMockMessages)
        }
        .navigationTitle("Settings")
    }
}
