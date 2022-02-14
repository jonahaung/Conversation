//
//  OutgoingSocket.swift
//  Conversation
//
//  Created by Aung Ko Min on 9/2/22.
//

import Foundation

final class OutgoingSocket: ObservableObject {
    private var connectedUsers: [String] = []
    var conId: String = ""
    private lazy var queue: OperationQueue = {
        $0.name = "OutgoingSocket"
        $0.maxConcurrentOperationCount = 1
        return $0
    }(OperationQueue())
    
    private var onSentMsgBlock: ((Msg) -> Void)?
    private var onAddMsg: ((Msg) -> Void)?
    
    @discardableResult
    func connect(with senders: [String], conId: String) -> Self {
        disconnect()
        self.conId = conId
        self.connectedUsers = senders
        return self
    }
    @discardableResult
    func disconnect() -> Self {
        queue.cancelAllOperations()
        queue.isSuspended = true
        onSentMsgBlock = nil
        onAddMsg = nil
        conId = ""
        return self
    }
    // 1
    @discardableResult
    func onAddMsg(block: @escaping (Msg) -> Void) -> Self {
        onAddMsg = block
        return self
    }
    
    @discardableResult
    func add(msg: Msg) async -> Self {
        let _ = PersistenceController.shared.create(msg: msg)
        onAddMsg?(msg)
        return self
    }
    
    // 2
    @discardableResult
    func onSentMsg(block: @escaping (Msg) -> Void) -> Self {
        onSentMsgBlock = block
        return self
    }
    @discardableResult
    func send(msg: Msg) -> Self {
        let operation = MsgSenderOperation(msg)
        operation.completionBlock = { [weak self] in
            if operation.isCancelled {
                return
            }
            DispatchQueue.main.async {
                operation.msg.applyAction(action: .MsgProgress(value: .Read))
                self?.onSentMsgBlock?(operation.msg)
            }
        }
        queue.addOperation(operation)
        return self
    }
}
