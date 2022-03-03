//
//  OutgoingSocket.swift
//  Conversation
//
//  Created by Aung Ko Min on 9/2/22.
//

import Foundation

class OutgoingSocket: ObservableObject {
    

    private var conId: String = ""

    func add(msg: Msg) {
        Task {
            if await save(msg: msg) {
                await send(msg: msg)
            }
        }
    }
    
    private func save(msg: Msg) async -> Bool {
        CMsg.create(msg: msg)
        Thread.sleep(forTimeInterval: TimeInterval(Int.random(in: 1...5)))
        return true
    }
    
    private func send(msg: Msg) async {
        await msg.applyAction(action: .MsgProgress(value: .Sent))
        await ToneManager.shared.playSound(tone: .sendMessage)
        Thread.sleep(forTimeInterval: TimeInterval(Int.random(in: 2...5)))
        await IncomingSocket.shard.generateRandomMsg()
    }
    
    deinit {
        Log("")
    }
}
