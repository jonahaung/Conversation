//
//  ChatScrollView.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct ChatScrollView<Content: View>: View {
    
    typealias ChatScrollViewProxy = (scrollView: ScrollViewProxy, geometry: GeometryProxy)
    @Environment(\.refresh) public var refreshAction: RefreshAction?
    
    @EnvironmentObject private var chatLayout: ChatLayout
    @EnvironmentObject private var datasource: ChatDatasource
    
    private let content: (_ proxy: ChatScrollViewProxy) -> Content
    
    @StateObject private var moreLoader = MoreLoader()
    private var timeSpacer = TimeSpacer()
    
    init(@ViewBuilder content: @escaping (_ proxy: ChatScrollViewProxy) -> Content) {
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollView in
                ScrollView(showsIndicators: false) {
                    VStack {
                        progressView
                        content(ChatScrollViewProxy(scrollView, geometry))
                    }
                    .anchorPreference(key: MoreLoaderKeys.PreKey.self, value: .bounds) {
                        guard timeSpacer.canreturn else { return nil}
                        return MoreLoaderKeys.PreData(bounds: geometry[$0], parentSize: geometry.size)
                    }
                    .onPreferenceChange(MoreLoaderKeys.PreKey.self) { pre in
                        guard let data = pre else { return }
                        if moreLoader.state == .None {
                            moreLoader.scrollDetector.send(data)
                        } else if moreLoader.state == .Loaded && data.top < moreLoader.resetTrashold {
                            moreLoader.state = .None
                        } else if data.top < 0 {
                            moreLoader.state = .None
                        }
                        chatLayout.positions.cached = (data.bounds, data.parentSize)
                    }
                    .onReceive(moreLoader.scrollPublisher) { data in
                        
                        if moreLoader.state == .None && (0.0...5.0).contains(data.top) {
                            Task {
                                await ToneManager.shared.vibrate(vibration: .soft)
                                moreLoader.state = .Loaded
                                let firstId = datasource.msgs.first?.id ?? ""
                                await refreshAction?()
                                await ToneManager.shared.vibrate(vibration: .rigid)
                                chatLayout.focusedItem = .init(id: firstId, anchor: .top, animated: false)
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    
    private var progressView: some View {
        Group {
            if moreLoader.state != .Loaded {
                ProgressView()
                    .padding()
            }
        }
    }
}
