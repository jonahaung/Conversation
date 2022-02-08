//
//  MsgDatasource.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import Foundation

class ChatDatasource: ObservableObject {
    
    var msgs = MockDatabase.msgs(for: 50)
    
    func getMoreMsg() async -> [Msg] {
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return MockDatabase.msgs(for: 50) + msgs
        }catch {
            print(error.localizedDescription)
            return []
        }
        
    }
}
