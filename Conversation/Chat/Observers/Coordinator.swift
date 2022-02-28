//
//  Coordinator.swift
//  Conversation
//
//  Created by Aung Ko Min on 28/2/22.
//

import SwiftUI


class Coordinator: ObservableObject {
    
    @Published var con: Con
    @MainActor internal var scrollItem: ScrollItem?
    @Published var selectedId: String?
    var showScrollButton = false
    internal var isAutoLoadingMessages = false
    @MainActor var inputBarRect: CGRect = .zero {
        willSet {
            adjustContentOffset(newValue: newValue, oldValue: inputBarRect)
        }
    }

    
    private let datasource: ChatDatasource
    private let layout = ChatLayout()
    
    init(con: Con) {
        self.con = con
        datasource = .init(con: con)
    }
    
    
    deinit { Log("Deinit") }
}
// ChatDatasource
extension Coordinator: ChatLayoutDelegate {

    @MainActor func add(msg: Msg) {
        datasource.add(msg: msg)
        updateUI()
        if !hasMoreNext {
            scrollToBottom(animated: true)
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
    
    var hasMoreNext: Bool {
        datasource.hasMoreNext
    }
    
    var hasMorePrevious: Bool {
        datasource.hasMorePrevious
    }
    
    func loadNext() async {
        await datasource.loadNext()
    }
    
    func loadPrevious() async {
        await datasource.loadPrevious()
    }
    
}
// ChatLayout
extension Coordinator {
    
    func connect(scrollView: UIScrollView) {
        layout.connect(scrollView: scrollView)
    }
    @MainActor func scrollToBottom(animated: Bool) {
        layout.scrollToBottom(animated: animated)
    }
    @MainActor func scrollTo(item: ScrollItem) {
        scrollItem = item
        updateUI()
    }
    @MainActor func adjustContentOffset(inputViewSizeDidChange difference: CGFloat) {
        layout.adjustContentOffset(inputViewSizeDidChange: difference)
    }
    @MainActor func adjustContentOffset(newValue: CGRect, oldValue: CGRect) {
        layout.adjustContentOffset(newValue: newValue, oldValue: oldValue)
    }
}

// Main
extension Coordinator {
    
    @MainActor func updateUI() {
        objectWillChange.send()
    }
    
    @MainActor func task() {
        if layout.delegate ==  nil {
            scrollTo(item: .init(id: 0, anchor: .bottom))
            layout.delegate = self
        }
    }
}
