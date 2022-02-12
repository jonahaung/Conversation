//
//  RoomPropertiesView.swift
//  Conversation
//
//  Created by Aung Ko Min on 12/2/22.
//

import SwiftUI

struct RoomPropertiesView: View {
    
    @EnvironmentObject private var roomProperties: RoomProperties
    
    var body: some View {
        Form {
            Picker(selection: $roomProperties.bgImage) {
                ForEach(RoomProperties.BgImage.allCases) {
                    Text($0.name)
                }
            } label: {
                Text(roomProperties.bgImage.name)
            }

            Toggle("Cell Draggable", isOn: $roomProperties.canDragCell)
            
            Stepper("Cell Spacing \(Int(roomProperties.cellSpacing))", value: $roomProperties.cellSpacing)
        }
        .navigationTitle("Room Properties")
    }
}
