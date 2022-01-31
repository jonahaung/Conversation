//
//  MsgDatasource.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import Foundation

class ChatDatasource: ObservableObject {
    
    var msgHandler: ChatActions?
    @Published var msgs: [Msg] = MockDatabase.msgs(for: 500)
}
