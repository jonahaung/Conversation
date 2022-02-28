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
            Stepper("Page Size \(appUserDefault.pagnitionSize)", value: $appUserDefault.pagnitionSize, in: 20...200)
        }
        .navigationTitle("Settings")
    }
}
