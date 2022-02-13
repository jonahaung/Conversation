//
//  NavigationLinkStyle.swift
//  MyBike
//
//  Created by Aung Ko Min on 28/11/21.
//

import SwiftUI

struct TapToPushStyle<Destination: View>: ViewModifier {
    
    let destination: Destination
    
    func body(content: Content) -> some View {
        return NavigationLink(destination: destination) {
            content
        }
        .isDetailLink(false)
        .buttonStyle(.borderless)
    }
}

extension View {
    func tapToPush<Destination: View>(_ destination: Destination) -> some View {
        ModifiedContent(content: self, modifier: TapToPushStyle(destination: destination))
    }
}
