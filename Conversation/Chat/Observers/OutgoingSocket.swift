//
//  OutgoingSocket.swift
//  Conversation
//
//  Created by Aung Ko Min on 9/2/22.
//

import Foundation

final class OutgoingSocket {
    
    static let shared = OutgoingSocket()
    
    lazy var queue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Send queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    private var onSentMsg: ((Msg) -> Void)?
    private var onAddMsg: ((Msg) -> Void)?
    
    
    private var connectedUsers: [String] = []
    
    @discardableResult
    func connect(with senders: [String]) -> Self {
        disconnect()
        connectedUsers = senders
        return self
    }
    
    @discardableResult
    func disconnect() -> Self {
        onSentMsg = nil
        return self
    }
    
    @discardableResult
    func onSentMsg(code: @escaping (Msg) -> Void) -> Self {
        onSentMsg = code
        return self
    }
    @discardableResult
    func onAddMsg(code: @escaping (Msg) -> Void) -> Self {
        onAddMsg = code
        return self
    }
    
    func add(msg: Msg) {
        onAddMsg?(msg)
    }
    
    func send(msg: Msg) {
        let operation = MsgSendOperation(msg)
        operation.completionBlock = { [weak self] in
            if operation.isCancelled {
                return
            }
            DispatchQueue.main.async {
                operation.msg.applyAction(action: .MsgProgress(value: .Sent))
                self?.onSentMsg?(operation.msg)
            }
        }
        queue.addOperation(operation)
    }
}


class MsgSendOperation: Operation {
    
    let msg: Msg
    
    init(_ msg: Msg) {
        self.msg = msg
    }
    
    override func main() {
        
        if isCancelled {
            return
        }
        
        guard msg.progress == .Sending else { return }
        if isCancelled {
            return
        }
        Thread.sleep(forTimeInterval: 2)
    }
}
