//
//  MsgDatasource.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import Foundation


class ChatDatasource: ObservableObject {
    
    @Published var msgs = MockDatabase.msgs(for: 50)
    
    func loadMore() -> FocusedItem? {
        if let first = msgs.first {
            msgs = MockDatabase.msgs(for: 50) + msgs
            return FocusedItem.init(id: first.id, anchor: .top, animated: false)
        }
        return nil
    }
}
