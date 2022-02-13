//
//  FullScreenPresenting.swift
//  MyBike
//
//  Created by Aung Ko Min on 29/11/21.
//

import SwiftUI

struct TapToPresentStyle<Destination: View>: ViewModifier {
    
    let destination: Destination
    let isFullScreen: Bool
    
    @State private var sheetIsPresented = false
    @State private var fullScreenIsPresented = false
    
    func body(content: Content) -> some View {
        Button{
            if isFullScreen {
                fullScreenIsPresented = true
            } else {
                sheetIsPresented = true
            }
        } label: {
            content
        }
        .fullScreenCover(isPresented: $fullScreenIsPresented) {
            destination
        }
        .sheet(isPresented: $sheetIsPresented) {
            destination
        }
    }
}


extension View {
    
    func tapToPresent<Destination: View>(_ view: Destination, _ isFullScreen: Bool = false) -> some View {
        ModifiedContent(content: self, modifier: TapToPresentStyle(destination: view, isFullScreen: isFullScreen))
    }

}
