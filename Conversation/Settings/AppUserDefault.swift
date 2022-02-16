//
//  AppUserDefault.swift
//  Conversation
//
//  Created by Aung Ko Min on 9/2/22.
//

import SwiftUI

final class AppUserDefault: ObservableObject {
    
    static let shared: AppUserDefault = {
        return $0
    }(AppUserDefault())
    
    private static let _autoGenerateMockMsgs = "autoGenerateMockMsgs"
    @AppStorage(AppUserDefault._autoGenerateMockMsgs)
    var autoGenerateMockMessages = true
    
    private static let _cellSpacing = "_cellSpacing"
    @AppStorage(AppUserDefault._cellSpacing)
    var chatCellSpacing = 2.0
    
    private static let _cellDraggable = "_cellDraggable"
    @AppStorage(AppUserDefault._cellSpacing)
    var canDragCell = false
    
}
