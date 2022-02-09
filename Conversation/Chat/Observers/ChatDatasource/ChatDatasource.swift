//
//  MsgDatasource.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import Foundation
import SwiftUI

class ChatDatasource: ObservableObject {
    
    var msgs = MockDatabase.msgs(for: 50)
    
    func getMoreMsg() async -> [Msg] {
        do {
            try await Task.sleep(nanoseconds: 2_000_000_000)
            return MockDatabase.msgs(for: 50) + msgs
        }catch {
            print(error.localizedDescription)
            return []
        }
        
    }
    
    func delete(msg: Msg) {
        if let index = msgs.firstIndex(of: msg) {
            msgs.remove(at: index)
            withAnimation {
                objectWillChange.send()
            }
        }
    }
}
