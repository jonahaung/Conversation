//
//  RoomPropertiesView.swift
//  Conversation
//
//  Created by Aung Ko Min on 12/2/22.
//

import SwiftUI

struct CConSettingsView: View {
    
    @EnvironmentObject private var cCon: CCon
    
    var body: some View {
        Form {
            Text(cCon.name!)
            Toggle("Show Avatar", isOn: $cCon.showAvatar)
            Toggle("Bubble Drag", isOn: $cCon.isBubbleDraggable)
            Picker(selection: $cCon.themeColor) {
                ForEach(CCon.ThemeColor.allCases, id: \.self) { themeColor in
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
            
            Stepper("Cell Spacing  \(Int(cCon.cellSpacing))", value: $cCon.cellSpacing, in: 0...10)
            Picker(selection: $cCon.bgImage) {
                ForEach(CCon.BgImage.allCases, id: \.self) { bgImage in
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
