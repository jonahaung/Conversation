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
    
    init() {
        let offset = max(0, PersistenceController.shared.cMsgsCount() - limit)
        msgs = PersistenceController.shared.cMsgs(limit: limit, offset: max(0, offset)).map(Msg.init)
    }
    
    func getMoreMsg() async -> [Msg] {
        do {
            let offset = PersistenceController.shared.cMsgsCount() - msgs.count - limit
            let new = PersistenceController.shared.cMsgs(limit: 50, offset: max(0, offset)).map(Msg.init)
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return new + msgs
        }catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func add(msg: Msg) async {
        msgs.append(msg)
        await ToneManager.shared.playSound(tone: .Tock)
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
