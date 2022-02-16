//
//  ChatScrollView.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct ChatScrollView<Content: View>: View {
    @Environment(\.refresh) private var refreshAction: RefreshAction?
    private let content: (_ scrollView: ScrollViewProxy) -> Content
    
    init(hasMoreData: Binding<Bool>, @ViewBuilder content: @escaping (_ scrollView: ScrollViewProxy) -> Content) {
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
                    
                    content(scrollView)
                        .overlay(progressView, alignment: .top)
                        .anchorPreference(key: ChatScrollViewPreferences.Key.self, value: .bounds) {
                            guard timeSpacer.canreturn else { return nil}
                            guard !chatLayout.isLoadingMore else { return nil }
                            let localFrame = geometry[$0]
                            let globalSize = geometry.size
                            return .init(loaclFrame: localFrame, globalSize: globalSize)
                        }
                        .onPreferenceChange(ChatScrollViewPreferences.Key.self) { [weak chatLayout] obj in
                            guard let chatLayout = chatLayout, let obj = obj else { return }
                            chatLayout.cached = obj
                            chatLayout.isScrolling = true
                            moreLoader.scrollDetector.send(obj)
                        }
                        .onReceive(moreLoader.scrollPublisher) { data in
                            chatLayout.isScrolling = false
                            if hasMoreData.wrappedValue && !chatLayout.isLoadingMore && (0.0...5.0).contains(data.offsetY) {
                                Task {
                                    guard let firstId = datasource.msgs.first?.id else { return }
                                    chatLayout.isLoadingMore = true
                                    await refreshAction?()
                                    await ToneManager.shared.playSound(tone: .Tock)
                                    scrollView.scrollTo(firstId, anchor: .top)
                                    scrollView.scrollTo(firstId, anchor: .top)
                                    chatLayout.isLoadingMore = false
                                }
                            }
                        }
                }
            }
        }
    }
    
    
    private var progressView: some View {
        Group {
            if hasMoreData.wrappedValue && chatLayout.isLoadingMore {
                VStack {
                    ProgressView()
                        .padding()
                }
            }
        }
    }
}
