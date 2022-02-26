//
//  ChatKit.swift
//  Conversation
//
//  Created by Aung Ko Min on 13/2/22.
//


import SwiftUI

enum ChatKit {

    static var bubbleRadius = CGFloat(UIFont.labelFontSize)
    static var cellAlignmentSpacing = CGFloat(35)
    static var cellMsgStatusSize = CGFloat(15)

    static var textBubbleColorIncoming = Color(uiColor: .secondarySystemGroupedBackground)
    static var textBubbleColorIncomingPlain = Color(uiColor: .systemGray6)
    
    static var mediaMaxWidth = CGFloat(250)
    static var textTextColorOutgoing = Color(uiColor: UIColor.systemBackground)
    static var textTextColorIncoming: Color? = nil
    
    static let cellLeftRightViewWidth = 15.00
}


typealias SomeAction = () async -> Void
