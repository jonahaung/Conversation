//
//  AppUserDefault.swift
//  Conversation
//
//  Created by Aung Ko Min on 9/2/22.
//

import SwiftUI

final class AppUserDefault: ObservableObject {
    
    static let shared: AppUserDefault = AppUserDefault()
    
    private static let _autoGenerateMockMsgs = "autoGenerateMockMsgs"
    @AppStorage(AppUserDefault._autoGenerateMockMsgs) var autoGenerateMockMessages = true
    
    private static let _cellDraggable = "_cellDraggable"
    @AppStorage(AppUserDefault._cellDraggable) var canDragCell = false
    
    private static let _pageSize = "pageSize"
    @AppStorage(_pageSize) var pagnitionSize = 50
    
}
