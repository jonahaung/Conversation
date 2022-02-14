//
//  ChatScrollView.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct ChatScrollView<Content: View>: View {
    @Environment(\.refresh) private var refreshAction: RefreshAction?
    private let content: (_ proxy: (scrollView: ScrollViewProxy, geometry: GeometryProxy)) -> Content
    
    init(hasMoreData: Binding<Bool>, @ViewBuilder content: @escaping (_ proxy: (scrollView: ScrollViewProxy, geometry: GeometryProxy)) -> Content) {
        self.content = content
        self.hasMoreData = hasMoreData
    }
    @EnvironmentObject private var chatLayout: ChatLayout
    @EnvironmentObject private var datasource: ChatDatasource
    @StateObject private var moreLoader = MoreLoader()
    private var hasMoreData: Binding<Bool>
    private let timeSpacer = TimeSpacer()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollView in
                ScrollView(showsIndicators: false) {
                    
                    content((scrollView, geometry))
                        .overlay(progressView, alignment: .top)
                        .anchorPreference(key: ChatScrollViewPreferences.Key.self, value: .bounds) {
                            guard timeSpacer.canreturn else { return nil}
                            
                            let localFrame = geometry[$0]
                            let globalSize = geometry.size
                            return .init(loaclFrame: localFrame, globalSize: globalSize)
                        }
                        .onPreferenceChange(ChatScrollViewPreferences.Key.self) { obj in
                            guard let obj = obj else { return }
                            chatLayout.positions.cached = obj
                            moreLoader.scrollDetector.send(obj)
                        }
                        .onReceive(moreLoader.scrollPublisher) { data in
                            chatLayout.positions.isScrolling = false
                            guard hasMoreData.wrappedValue else { return }
                            if moreLoader.state == .None && (0.0...5.0).contains(data.offsetY) {
                                Task {
                                    moreLoader.state = .Loaded
                                    guard let firstId = datasource.msgs.first?.id else { return }
                                    await ToneManager.shared.playSound(tone: .Tock)
                                    await refreshAction?()
                                    await ToneManager.shared.vibrate(vibration: .rigid)
                                    scrollView.scrollTo(firstId, anchor: .top)
                                    scrollView.scrollTo(firstId, anchor: .top)
                                    moreLoader.state = .None
                                    
                                }
                            }
                        }
                    
                }
                
            }
        }
    }
    
    
    private var progressView: some View {
        Group {
            if hasMoreData.wrappedValue && moreLoader.state == .Loaded {
                VStack {
                    ProgressView()
                        .padding()
                }
            }
        }
    }
}
