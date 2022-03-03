//
//  IncomingSocket.swift
//  Conversation
//
//  Created by Aung Ko Min on 9/2/22.
//

import UIKit


@Socket class IncomingSocket: ObservableObject {
    
    static let shard = IncomingSocket()
    
    private init() {
        
    }
    private var conId: String?
    
    
    func connect(with conId: String) {
        disconnect()
        self.conId = conId
    }
    

    func disconnect() {
        conId = ""
    }

    
    private func saveMessage(msg: Msg) {
        CMsg.create(msg: msg)
    }
    

    func generateRandomMsg() {
        guard let conId = conId else {
            return
        }
        guard AppUserDefault.shared.autoGenerateMockMessages else { return }
        setTyping(isTyping: true)
        Thread.sleep(forTimeInterval: TimeInterval(Int.random(in: 1...3)))
        setTyping(isTyping: false)
        Thread.sleep(forTimeInterval: TimeInterval(Int.random(in: 1...3)))
        let msg = Msg(conId: conId, msgType: .Text, rType: .Receive, progress: .Read)
        
        let text = [Lorem.sentence, Lorem.shortTweet, Lorem.tweet, Lorem.fullName, Lorem.title].random() ?? Lorem.emailAddress
        msg.textData = .init(text: text)
        saveMessage(msg: msg)
        showMsg(msg: msg)
        
    }
    
    private func showMsg(msg: Msg) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .MsgNoti, object: MsgNoti(msg: msg))
        }
    }
    private func setTyping(isTyping: Bool ) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .MsgNoti, object: MsgNoti(isTyping: isTyping))
        }
    }
    deinit {
        Log("")
    }
}

struct MsgNoti {
    
    var msg: Msg? = nil
    var isTyping: Bool? = nil
    
    init(msg: Msg) {
        self.msg = msg
    }
    init(isTyping: Bool) {
        self.isTyping = isTyping
    }
}

extension Notification.Name {
    static let MsgNoti = Notification.Name("Notification.Conversation.MsgDidReceive")
 }

