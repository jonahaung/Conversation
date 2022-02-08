//
//  Extensions.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

extension View {
    var any: AnyView { AnyView(self) }
}

// Extensions
private struct FrameSize: ViewModifier {
    let size: CGSize?
    
    func body(content: Content) -> some View {
        content
            .frame(width: size?.width, height: size?.height)
    }
}
extension View {
    func frame(size: CGSize?) -> some View {
        return modifier(FrameSize(size: size))
    }
}
