//
//  ChatKit.swift
//  Conversation
//
//  Created by Aung Ko Min on 13/2/22.
//


import SwiftUI

enum ChatKit {

    static let bubbleRadius = CGFloat(14)
    
    static let cellAlignmentSpacing = CGFloat(30)
    static let cellMsgStatusSize = CGFloat(15)
    static let cellHorizontalPadding = CGFloat(8)
    static let textBubbleColorIncoming = Color(uiColor: .secondarySystemGroupedBackground)
    static let textBubbleColorIncomingPlain = Color(uiColor: .systemGray6)
    static let cellLeftRightViewWidth = 15.00
    
    static let mediaMaxWidth = CGFloat(250)
    static let textTextColorOutgoing = Color(uiColor: UIColor.systemBackground)
    static let textTextColorIncoming: Color? = nil

}


typealias SomeAction = () async -> Void
