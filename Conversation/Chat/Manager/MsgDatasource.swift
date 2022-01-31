//
//  MsgDatasource.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import Foundation

class MsgDatasource: ObservableObject {
    var msgHandler: MsgStateChangeHandler?
    
    @Published var msgs: [Msg] = MockDatabase.msgs(for: 500)
}
