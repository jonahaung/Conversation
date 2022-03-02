//
//  Coordinator.swift
//  Conversation
//
//  Created by Aung Ko Min on 28/2/22.
//

import SwiftUI


class Coordinator: ObservableObject {
    
    var con: Con
    @MainActor var scrollItem: ScrollItem?
    @Published var selectedId: String?
    var showScrollButton = false {
        willSet{
            guard newValue != showScrollButton else { return }
            objectWillChange.send()
        }
    }
    var inputBarRect: CGRect = .zero {
        willSet {
            adjustContentOffset(newValue: newValue, oldValue: inputBarRect)
        }
    }

    
    private let datasource: ChatDatasource
    private let layout = ChatLayout()
    
    init(con: Con) {
        self.con = con
        datasource = .init(conId: con.id)
    }
    
    
    deinit { Log("Deinit") }
}
// ChatDatasource
extension Coordinator: ChatLayoutDelegate {

    func add(msg: Msg) async {
        await datasource.add(msg: msg)
        await updateUI()
        if !showScrollButton {
           await scrollToBottom(animated: true)
        }
    }
    
    func delete(msg: Msg) async {
        datasource.delete(msg: msg)
    }
    
    func msgStyle(for msg: Msg, at index: Int) -> MsgStyle {
        datasource.msgStyle(for: msg, at: index, selectedId: selectedId)
    }
    
    var msgs: [Msg] {
        datasource.msgs
    }

    var hasMorePrevious: Bool {
        datasource.hasMorePrevious
    }
    
    func loadNext() async {
        if datasource.hasMoreNext, let scrollId = msgs.last?.id {
            await datasource.loadNext()
            scrollTo(item: .init(id: scrollId, anchor: .bottom))
        }
    }
    
    func loadPrevious() async {
        if datasource.hasMorePrevious, let scrollId = msgs.first?.id {
            await datasource.loadPrevious()
            scrollTo(item: .init(id: scrollId, anchor: .top))
        }
    }
    
    func resetToBottom() {
        Task {
            await datasource.resetToBottom()
            await scrollTo(item: .init(id: 0, anchor: .bottom, animate: true))
        }
    }
}
// ChatLayout
extension Coordinator {
    
    func connect(scrollView: UIScrollView) {
        if layout.connect(scrollView: scrollView) {

        }
    }
    @MainActor func scrollToBottom(animated: Bool) {
        layout.scrollToBottom(animated: animated)
    }
    @MainActor func scrollTo(item: ScrollItem) {
        scrollItem = item
        updateUI()
    }
    
    func adjustContentOffset(newValue: CGRect, oldValue: CGRect) {
        let isHeightChanged = newValue.height != oldValue.height
        let isPositionChanged = newValue.maxY != oldValue.maxY
       
        if isPositionChanged {
            layout.adjustContentOffset(newValue: newValue, oldValue: oldValue)
        } else if isHeightChanged {
            let heightDifference = newValue.height - oldValue.height
            if heightDifference > 0 {
                layout.adjustContentOffset(inputViewSizeDidChange: heightDifference)
            }
        }
    }
}

// Main
extension Coordinator {
    
    @MainActor func updateUI() {
        objectWillChange.send()
    }
    @MainActor func task() {
        if layout.delegate == nil {
            scrollTo(item: .init(id: 0, anchor: .bottom))
            layout.delegate = self
        }
    }
}
