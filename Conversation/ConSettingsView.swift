//
//  RoomPropertiesView.swift
//  Conversation
//
//  Created by Aung Ko Min on 12/2/22.
//

import SwiftUI

struct ConSettingsView: View {
    
    @EnvironmentObject private var con: Con
    
    var body: some View {
        Form {
            Text(con.name)
            Toggle("Show Avatar", isOn: $con.showAvatar)
            Toggle("Bubble Drag", isOn: $con.isBubbleDraggable)
            Toggle("Paginition Enabled", isOn: $con.isPagingEnabled)
            
            Picker(selection: $con.themeColor) {
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
            
            Stepper("Cell Spacing  \(Int(con.cellSpacing))", value: $con.cellSpacing, in: 0...10)
            Picker(selection: $con.bgImage) {
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
