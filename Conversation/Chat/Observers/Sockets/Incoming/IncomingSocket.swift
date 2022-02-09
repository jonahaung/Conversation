//
//  IncomingSocket.swift
//  Conversation
//
//  Created by Aung Ko Min on 9/2/22.
//

import UIKit

final class IncomingSocket: ChatRoomSocket {
    
    static var shared = IncomingSocket()
    
    private lazy var queue: OperationQueue = {
        $0.name = "IncomingSocket"
        $0.maxConcurrentOperationCount = 1
        return $0
    }(OperationQueue())
    
    private var onNewMsgBlock: ((Msg) -> Void)?
    private var onTypingStatusBlock: ((Bool) -> Void)?
    
    private(set) var timer: Timer?
    
    @discardableResult
    override func connect(with senders: [String]) -> Self {
        super.connect(with: senders)
        if AppUserDefault.shared.autoGenerateMockMessages {
            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        }
        return self
    }
    
    @discardableResult
    override func disconnect() -> Self {
        timer?.invalidate()
        timer = nil
        onTypingStatusBlock = nil
        onNewMsgBlock = nil
        return super.disconnect()
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
        let op = MsgReceiverOperation(msg)
        op.completionBlock = { [weak self] in
            if op.isCancelled {
                return
            }
            DispatchQueue.main.async {
                op.msg.applyAction(action: .MsgProgress(value: .Read))
                self?.onNewMsgBlock?(op.msg)
            }
        }
        queue.addOperation(op)
    }
    
    @objc
    private func handleTimer() {
        onTypingStatusBlock?(Bool.random())
        let msg = Msg(msgType: .Text(data: .init(text: Lorem.sentence)), rType: .Receive, progress: .Sent)
        receive(msg: msg)
    }
}
