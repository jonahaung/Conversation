//
//  MsgDatasource.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import Foundation
import SwiftUI

class ChatDatasource: ObservableObject {
    
    @Published var msgs = [Msg]()
    
    private var limit = 50
    private let conId: String
    private let persistance = PersistenceController.shared
    var hasMoreData = true
    
    init(conId: String) {
        self.conId = conId
        let offset = max(0, PersistenceController.shared.cMsgsCount(conId: conId) - limit)
        msgs = persistance.cMsgs(conId: conId, limit: limit, offset: offset).map(Msg.init)
    }
    
    func getMoreMsg() async -> [Msg]? {
        
        guard hasMoreData else { return nil }
        
        let count = persistance.cMsgsCount(conId: conId)
        
        if count == msgs.count {
            return nil
        }
        do {
            let offset = count - msgs.count - limit
            
            var lmt = self.limit
            if offset < 0 {
                lmt = lmt + offset
            }
            let new = persistance.cMsgs(conId: conId, limit: lmt, offset: max(0, offset)).map(Msg.init)
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return new + msgs
        }catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func add(msg: Msg) async {
        msgs.append(msg)
    }
    
    func delete(msg: Msg) {
        
        if let index = msgs.firstIndex(of: msg) {
            msgs.remove(at: index)
            PersistenceController.shared.delete(id: msg.id)
        }
    }
    
    deinit {
        Log("")
    }
}
