//
//  OutgoingSocket.swift
//  Conversation
//
//  Created by Aung Ko Min on 9/2/22.
//

import Foundation

final class OutgoingSocket: ObservableObject {
    
    var conId: String = ""
    private lazy var queue: OperationQueue = {
        $0.name = "OutgoingSocket"
        $0.maxConcurrentOperationCount = 1
        return $0
    }(OperationQueue())
    
    private var onSentMsgBlock: ((Msg) -> Void)?
    private var onAddMsg: ((Msg) -> Void)?
    
    @discardableResult
    func connect(with conId: String) -> Self {
        disconnect()
        self.conId = conId
        return self
    }
    @discardableResult
    func disconnect() -> Self {
        queue.cancelAllOperations()
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
        operation.completionBlock = { [weak self, weak msg, weak operation] in
            guard let op = operation, !op.isCancelled, let self = self, let msg = msg else { return }
            DispatchQueue.main.async {
                msg.applyAction(action: .MsgProgress(value: .Sent))
                self.onSentMsgBlock?(msg)
            }
        }
        queue.addOperation(operation)
        return self
    }
    
    deinit {
        Log("")
    }
}
