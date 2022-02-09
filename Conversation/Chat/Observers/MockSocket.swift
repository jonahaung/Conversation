/*
 MIT License
 
 Copyright (c) 2017-2019 MessageKit
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit


final class MockSocket {
    
    static var shared = MockSocket()
    
    private var timer: Timer?

    
    private var onMsgCode: ((Msg) -> Void)?
    
    private var onTypingStatusCode: (() -> Void)?
    
    private var connectedUsers: [String] = []
    private var msgs = [Msg]()
    
    private init() {}
    
    @discardableResult
    func connect(with senders: [String]) -> Self {
        disconnect()
        connectedUsers = senders
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        return self
    }
    
    @discardableResult
    func disconnect() -> Self {
        timer?.invalidate()
        timer = nil
        onTypingStatusCode = nil
        onMsgCode = nil
        return self
    }
    
    @discardableResult
    func onNewMsg(code: @escaping (Msg) -> Void) -> Self {
        onMsgCode = code
        return self
    }
    
    @discardableResult
    func onTypingStatus(code: @escaping () -> Void) -> Self {
        onTypingStatusCode = code
        return self
    }
    
    @objc
    private func handleTimer() {
        if let msg = msgs.first {
            onMsgCode?(msg)
            msgs.removeFirst()
            Task {
                await ToneManager.shared.playSound(tone: .receivedMessage)
            }
        } else {
            let msg = Msg(msgType: .Text(data: .init(text: Lorem.sentence)), rType: .Receive, progress: .Read)
            msgs.append(msg)
            onTypingStatusCode?()
        }
    }
    @discardableResult
    func add(msg: Msg) -> Self {
        onMsgCode?(msg)
        return self
    }
}
