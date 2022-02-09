//
//  AppUserDefault.swift
//  Conversation
//
//  Created by Aung Ko Min on 9/2/22.
//

import SwiftUI

final class AppUserDefault: ObservableObject {
    
    static let shared = AppUserDefault()
    
    private static let _showTimeLabel = "showTimeLabel"
    private static let _autoGenerateMockMsgs = "autoGenerateMockMsgs"
   
    
    @AppStorage(AppUserDefault._showTimeLabel)
    var showTimeLabels = true
    
    @AppStorage(AppUserDefault._autoGenerateMockMsgs)
    var autoGenerateMockMessages = true
    
}
