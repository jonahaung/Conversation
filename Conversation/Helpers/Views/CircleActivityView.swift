//
//  CircleActivityView.swift
//  Conversation
//
//  Created by Aung Ko Min on 6/2/22.
//

import SwiftUI

public struct CircleActivityView: View {
    
    public var lineWidth: CGFloat
    public var pathColor: Color
    public var lineColor: Color
    
    public init(lineWidth: CGFloat = 30, pathColor: Color, lineColor: Color) {
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.pathColor = pathColor
    }
    
    @State private var isLoading: Bool = false
    
    public var body: some View {
        ZStack {
            Circle()
                .stroke(pathColor, lineWidth: lineWidth)
                .opacity(0.3)
            Circle()
                .trim(from: 0, to: 0.5)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(lineColor)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                .onAppear { self.isLoading.toggle() }
        }
    }
}
