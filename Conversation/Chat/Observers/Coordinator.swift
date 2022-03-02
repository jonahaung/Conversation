//
//  Coordinator.swift
//  Conversation
//
//  Created by Aung Ko Min on 28/2/22.
//

import SwiftUI


class Coordinator: ObservableObject {
    
    @Published var con: Con
    var scrollItem: ScrollItem?
    @Published var selectedId: String?
    var showScrollButton = false
    @MainActor var inputBarRect: CGRect = .zero {
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

    @MainActor func add(msg: Msg) {
        datasource.add(msg: msg)
        if !hasMoreNext {
            updateUI()
            layout.scrollToBottom(animated: true)
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
    
    func loadNext() {
        let scrollId = msgs.last?.id ?? ""
        datasource.loadNext()
        scrollItem = .init(id: scrollId, anchor: .bottom)
        Task {
            await updateUI()
        }
    }
    
    func loadPrevious() {
        let scrollId = msgs.first?.id ?? ""
        datasource.loadPrevious()
        scrollItem = .init(id: scrollId, anchor: .top)
        Task {
            await updateUI()
        }
    }
    
    @MainActor func resetToBottom() async {
        if hasMoreNext {
            await datasource.resetToBottom()
        }
        scrollTo(item: .init(id: 0, anchor: .bottom, animate: true))
    }
}
// ChatLayout
extension Coordinator {
    
    @MainActor func connect(scrollView: UIScrollView) {
        if layout.connect(scrollView: scrollView) {

        }
    }

    @MainActor func scrollTo(item: ScrollItem) {
        scrollItem = item
        updateUI()
    }
    
    @MainActor func adjustContentOffset(newValue: CGRect, oldValue: CGRect) {
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
        print("update")
    }
    
    @MainActor func task() {
        if layout.delegate == nil {
            scrollTo(item: .init(id: 0, anchor: .bottom))
            layout.delegate = self
        }
    }
}

