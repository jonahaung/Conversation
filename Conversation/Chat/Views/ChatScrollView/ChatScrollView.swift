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
        GeometryReader { geometry in
            ScrollViewReader { scrollView in
                ScrollView(showsIndicators: false) {
                    progressView
                    content(ChatScrollViewProxy(scrollView, geometry))
                        .redacted(reason: moreLoader.isLoading ? .placeholder : [])
                        .anchorPreference(key: MoreLoaderKeys.PreKey.self, value: .top) {
                            return MoreLoaderKeys.PreData(top: $0)
                        }
                        .onPreferenceChange(MoreLoaderKeys.PreKey.self) {
                            guard moreLoader.isLoading == false else { return }
                            moreLoader.scrollDetector.send($0)
                        }
                        .onReceive(moreLoader.scrollPublisher) {
                            guard let anchor = $0.top else { return }
                            
                            let offset = geometry[anchor].y
                            if offset > moreLoader.threshold {
                                Task {
                                    guard moreLoader.isLoading == false else { return }
                                    moreLoader.isLoading = true
                                    await refreshAction?()
                                    moreLoader.isLoading = false
                                }
                            }
                        }
                }
                
            }
        }
        .coordinateSpace(name: "chatScrollView")
    }
    
    private var progressView: some View {
        VStack {
            if moreLoader.isLoading {
                ProgressView()
            } else {
                Text("more messages ..")
                    .italic()
                    .foregroundStyle(.tertiary)
            }
        }
        .frame(height: 30)
        .padding(.top)
    }
}

