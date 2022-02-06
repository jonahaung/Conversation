//
//  ChatScrollView.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct ChatScrollView<Content: View>: View {
    
    typealias ChatScrollViewProxy = (scrollView: ScrollViewProxy, geometry: GeometryProxy)
    
    private let content: (_ proxy: ChatScrollViewProxy) -> Content
    @Environment(\.refresh) public var refreshAction: RefreshAction?
    @StateObject private var moreLoader = MoreLoader()
    
    init(@ViewBuilder content: @escaping (_ proxy: ChatScrollViewProxy) -> Content) {
        self.content = content
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { geometry in
                ScrollViewReader { scrollView in
                    ScrollView(showsIndicators: false) {
                        content(ChatScrollViewProxy(scrollView, geometry))
                            .padding(.horizontal, 8)
                            .anchorPreference(key: MoreLoaderKeys.PreKey.self, value: .top) {
                                return MoreLoaderKeys.PreData(top: geometry[$0].y)
                            }
                    }
                    .onPreferenceChange(MoreLoaderKeys.PreKey.self) {
                        moreLoader.scrollDetector.send($0)
                    }
                }
            }
            progressView
        }
        .coordinateSpace(name: "chatScrollView")
        .onReceive(moreLoader.scrollPublisher) {
            if $0.top > moreLoader.threshold && !moreLoader.isLoading, let refreshAction = refreshAction {
                Task {
                    moreLoader.isLoading = true
                    await ToneManager.shared.vibrate(vibration: .rigid)
                    await refreshAction()
                    moreLoader.isLoading = false
                }
            }
        }
    }
    
    private var progressView: some View {
        VStack {
            if moreLoader.isLoading {
                CircleActivityView(lineWidth: 3, pathColor: Color(uiColor: .systemBackground), lineColor: .orange)
                    .frame(width: 25, height: 25)
                    .padding()
            }
        }
    }
}

