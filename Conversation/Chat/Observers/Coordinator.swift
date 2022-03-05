//
//  Coordinator.swift
//  Conversation
//
//  Created by Aung Ko Min on 28/2/22.
//

import SwiftUI
import Combine

class Coordinator: ObservableObject {
    
    @Published var con: Con
    var scrollItem: ScrollItem?
    @Published var selectedId: String?
    

    let datasource: ChatDatasource
    var layout = ChatLayout()
   
    init(con: Con) {
        self.con = con
        datasource = .init(conId: con.id)
    }
    
    
    deinit {
        Log("Deinit")
        
    }
}
// ChatDatasource
extension Coordinator: ChatLayoutDelegate {

    var showScrollButton: Bool { datasource.hasMoreNext }
    var shouldScrollToButtonForNewMsg: Bool {
        datasource.hasMoreNext == false && layout.shouldScrollToBottom
    }
    
    func add(msg: Msg) {
        DispatchQueue.main.async {
            self.datasource.add(msg: msg)
            self.updateUI()
            if self.shouldScrollToButtonForNewMsg {
                self.layout.scrollToBottom(animated: true)
            }
        }
    }
    
    
    
    func msgStyle(for msg: Msg, at index: Int) -> MsgStyle {
        datasource.msgStyle(for: msg, at: index, selectedId: selectedId)
    }
    
    var msgs: [Msg] {
        datasource.msgs
    }

    @MainActor
    func loadNext() async {
        if datasource.hasMoreNext, let scrollId = msgs.last?.id {
            await datasource.loadNext()
            scrollTo(item: .init(id: scrollId, anchor: .bottom))
            
        }
    }
    @MainActor
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
   
    @MainActor func scrollTo(item: ScrollItem) {
        scrollItem = item
        updateUI()
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
