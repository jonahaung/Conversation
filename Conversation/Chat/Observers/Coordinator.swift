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
    

    var datasource: ChatDatasource!
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

    var showScrollButton: Bool { datasource.hasMoreNext || !layout.shouldScrollToBottom }
    var shouldScrollToButtonForNewMsg: Bool { datasource.hasMoreNext == false && layout.shouldScrollToBottom }

    func add(msg: Msg) {
        DispatchQueue.main.async {
            self.datasource.add(msg: msg)
            self.updateUI()
            if self.shouldScrollToButtonForNewMsg {
                self.layout.scrollToBottom(animated: true)
            }
        }
    }
    
    @MainActor
    func loadNext() {
        if datasource.hasMoreNext, let scrollId = datasource.msgs.last?.id {
            datasource.loadNext()
            updateUI()
            scrollTo(item: .init(id: scrollId, anchor: .bottom))
            
        }
    }
    
    @MainActor
    func loadPrevious() {
        if datasource.hasMorePrevious, let scrollId = datasource.msgs.first?.id {
            datasource.loadPrevious()
            updateUI()
            scrollTo(item: .init(id: scrollId, anchor: .top))
        }
    }
    
    @MainActor func resetToBottom() {
        datasource = ChatDatasource(conId: con.id)
        scrollTo(item: .init(id: 0, anchor: .bottom, animate: true))
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
            con.task()
        }
    }
}


extension Coordinator: MsgStyleFactory {
    
    var msgs: [Msg] {
        datasource.msgs
    }
    
    var cachedMsgStyles: [String : MsgStyle] {
        get {
            datasource.cachedMsgStyles
        }
        set {
            datasource.cachedMsgStyles = newValue
        }
    }
}
