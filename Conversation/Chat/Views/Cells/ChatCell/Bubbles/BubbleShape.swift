//
//  BubbleShape.swift
//  Conversation
//
//  Created by Aung Ko Min on 9/2/22.
//

import SwiftUI

struct BubbleShape: Shape {
    
    let corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        Path(UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 17, height: 17)).cgPath)
    }
}

