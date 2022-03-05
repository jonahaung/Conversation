//
//  MsgDatasource.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import Foundation
import SwiftUI


import CoreData

class ChatDatasource: NSObject, MsgStyleFactory {
    
    internal var cachedMsgStyles = [String: MsgStyle]()
    
    private var slidingWindow: SlidingDataSource<Msg>
    
    private let pageSize = AppUserDefault.shared.pagnitionSize
    private var preferredMaxWindowSize: Int { pageSize * 3 }
    
    var msgs: [Msg] {
        return self.slidingWindow.itemsInWindow
    }
  
    
    init(conId: String) {
        let items = CMsg.msgs(for: conId)
        slidingWindow = SlidingDataSource(items: items.map(Msg.init), pageSize: pageSize)
    }
    
    var hasMoreNext: Bool {
        return self.slidingWindow.hasMore()
    }
    
    var hasMorePrevious: Bool {
        return self.slidingWindow.hasPrevious()
    }

    func add(msg: Msg) {
        slidingWindow.insertItem(msg, position: .bottom)
    }
    
    func delete(msg: Msg) {
        CMsg.delete(id: msg.id)
        slidingWindow.remove(msg: msg)
    }
    
    @MainActor func update(id: String) {
        if let msg = slidingWindow.item(for: id) {
            if msg.update() {
                msg.updateUI()
                ToneManager.shared.playSound(tone: .Tock)
            }
        }
        
    }
    
    func loadNext() async {
        self.slidingWindow.loadNext()
        self.slidingWindow.adjustWindow(focusPosition: 1, maxWindowSize: self.preferredMaxWindowSize)
    }
    
    func loadPrevious() async {
        self.slidingWindow.loadPrevious()
        self.slidingWindow.adjustWindow(focusPosition: 0, maxWindowSize: self.preferredMaxWindowSize)
    }
    func resetToBottom() async {
        await withTaskGroup(of: Void.self) { group in
            while hasMoreNext {
                group.addTask {
                    await self.loadNext()
                }
                
            }
        }
    }
    
    func adjustNumberOfMessages(preferredMaxCount: Int?, focusPosition: Double) async -> Bool {
        return self.slidingWindow.adjustWindow(focusPosition: focusPosition, maxWindowSize: preferredMaxCount ?? self.preferredMaxWindowSize)
    }
    
    deinit {
        Log("")
    }
}
