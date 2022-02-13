//
//  ChatKit.swift
//  Conversation
//
//  Created by Aung Ko Min on 13/2/22.
//


import SwiftUI


enum ChatKit {

    static var bubbleRadius = CGFloat(15)
    static var cellAlignmentSpacing = CGFloat(45)
    static var cellMsgStatusSize = CGFloat(15)

    static var textBubbleColorOutgoing = Color.accentColor.opacity(0.9)
    static var textBubbleColorIncoming = Color(uiColor: .systemGray6).opacity(0.8)

    static var textTextColorOutgoing = Color(uiColor: UIColor.systemBackground)
    static var textTextColorIncoming: Color? = nil

    static var textFont = Font.custom("Righteous-Regular", size: UIFont.labelFontSize)
}
