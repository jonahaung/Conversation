//
//  MsgDatasource.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import Foundation

class ChatDatasource: ObservableObject {
    
    @Published var msgs: [Msg] = MockDatabase.msgs(for: 100)
}
