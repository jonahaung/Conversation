//
//  RoomPropertiesView.swift
//  Conversation
//
//  Created by Aung Ko Min on 12/2/22.
//

import SwiftUI

struct ConSettingsView: View {
    
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        Form {
            Text(coordinator.con.name)
            Toggle("Show Avatar", isOn: $coordinator.con.showAvatar)
            Toggle("Bubble Drag", isOn: $coordinator.con.isBubbleDraggable)
            Toggle("Paginition Enabled", isOn: $coordinator.con.isPagingEnabled)
            
            Picker(selection: $coordinator.con.themeColor) {
                ForEach(Con.ThemeColor.allCases, id: \.self) { themeColor in
                    Label {
                        Text(themeColor.name)
                    } icon: {
                        Image(systemName: "circle.fill")
                            .foregroundColor(themeColor.color)
                    }
                }
            } label: {
                Text("Theme Color")
            }
            
            Stepper("Cell Spacing  \(Int(coordinator.con.cellSpacing))", value: $coordinator.con.cellSpacing, in: 0...10)
            Stepper("Bubble Cornor Radius  \(Int(coordinator.con.bubbleCornorRadius))", value: $coordinator.con.bubbleCornorRadius, in: 0...30)
            
            Picker(selection: $coordinator.con.bgImage) {
                ForEach(Con.BgImage.allCases, id: \.self) { bgImage in
                    bgImage.image
                        .padding()
                }
            } label: {
                Text("")
            }
            .labelsHidden()
        }
        .navigationTitle("Conversation Settings")
    }
}
