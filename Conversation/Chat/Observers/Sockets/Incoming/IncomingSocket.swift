//
//  IncomingSocket.swift
//  Conversation
//
//  Created by Aung Ko Min on 9/2/22.
//

import UIKit

final class IncomingSocket: ObservableObject {
    
    private var conId: String = ""
    
    private lazy var queue: OperationQueue = {
        $0.name = "IncomingSocket"
        $0.maxConcurrentOperationCount = 1
        return $0
    }(OperationQueue())
    private var timer: Timer?
    
    private var onNewMsgBlock: ((Msg) -> Void)?
    private var onTypingStatusBlock: ((Bool) -> Void)?
    
    
    
    @discardableResult
    func connect(with conId: String) -> Self {
        disconnect()
        self.conId = conId
        if AppUserDefault.shared.autoGenerateMockMessages {
            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        }
        return self
    }
    
    @discardableResult
    func disconnect() -> Self {
        timer?.invalidate()
        timer = nil
        queue.cancelAllOperations()
        conId = ""
        onTypingStatusBlock = nil
        onNewMsgBlock = nil
        return self
    }
    
    @discardableResult
    func onNewMsg(block: @escaping (Msg) -> Void) -> Self {
        onNewMsgBlock = block
        return self
    }
    
    @discardableResult
    func onTypingStatus(block: @escaping (Bool) -> Void) -> Self {
        onTypingStatusBlock = block
        return self
    }
    
    private func receive(msg: Msg) {
        let operation = MsgReceiverOperation(msg)
        operation.completionBlock = {  [weak self, weak msg, weak operation] in
            guard let op = operation, !op.isCancelled, let self = self, let msg = msg else { return }
            if op.isCancelled {
                return
            }
            DispatchQueue.main.async {
                msg.applyAction(action: .MsgProgress(value: .Read))
                CMsg.create(msg: msg)
                self.onNewMsgBlock?(msg)
            }
        }
        queue.addOperation(operation)
    }
    
    @objc
    private func handleTimer() {
        onTypingStatusBlock?(Bool.random())
        let rType = [Msg.RecieptType.Send, .Receive].random() ?? .Send
        let progress = rType == .Send ? Msg.MsgProgress.Sending : .SendingFailed
        let msg = Msg(conId: conId, msgType: .Text, rType: rType, progress: progress)
        
        let text = [Lorem.sentence, Lorem.shortTweet, Lorem.tweet, Lorem.fullName, Lorem.title].random() ?? Lorem.emailAddress
        msg.textData = .init(text: text)
        receive(msg: msg)
    }
    
    deinit {
        Log("")
    }
}
