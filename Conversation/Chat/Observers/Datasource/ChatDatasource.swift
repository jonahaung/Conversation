//
//  MsgDatasource.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import Foundation

class ChatDatasource {
    
    
    
    private var slidingWindow: SlidingDataSource<Msg>
    
    private let pageSize: Int
    private var preferredMaxWindowSize: Int
    
    var msgs: [Msg] {
        slidingWindow.itemsInWindow
    }
    
    init(conId: String) {
        let items = CMsg.msgs(for: conId)
        pageSize = AppUserDefault.shared.pagnitionSize
        preferredMaxWindowSize = pageSize * 3
        slidingWindow = SlidingDataSource(items: items.map(Msg.init), pageSize: pageSize)
    }
    
    var hasMoreNext: Bool {
        return self.slidingWindow.hasMore()
    }
    
    var hasMorePrevious: Bool {
        return self.slidingWindow.hasPrevious()
    }
    
    @MainActor
    func add(msg: Msg) {
        slidingWindow.insertItem(msg, position: .bottom)
    }
    
    @MainActor
    func remove(msg: Msg) {
        if CMsg.delete(id: msg.id) {
            slidingWindow.remove(where: { $0.id == msg.id })
        }
    }
    
    @MainActor
    func msg(for id: String) -> Msg? {
        slidingWindow.item(for: id)
    }
    
    @MainActor
    func update(id: String) {
        if let msg = slidingWindow.item(for: id), msg.update() {
            msg.updateUI()
        }
    }
    
    @MainActor
    func loadNext() {
        self.slidingWindow.loadNext()
        self.slidingWindow.adjustWindow(focusPosition: 1, maxWindowSize: self.preferredMaxWindowSize)
    }
    @MainActor
    func loadPrevious() {
        self.slidingWindow.loadPrevious()
        self.slidingWindow.adjustWindow(focusPosition: 0, maxWindowSize: self.preferredMaxWindowSize)
    }
    
    @MainActor
    func adjustNumberOfMessages(preferredMaxCount: Int?, focusPosition: Double) async -> Bool {
        return self.slidingWindow.adjustWindow(focusPosition: focusPosition, maxWindowSize: preferredMaxCount ?? self.preferredMaxWindowSize)
    }
    
    deinit {
        Log("")
    }
}
