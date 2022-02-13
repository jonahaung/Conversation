//
//  ChatScrollView.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct ChatScrollView<Content: View>: View {
    
    private let content: (_ proxy: (scrollView: ScrollViewProxy, geometry: GeometryProxy)) -> Content
    
    init(@ViewBuilder content: @escaping (_ proxy: (scrollView: ScrollViewProxy, geometry: GeometryProxy)) -> Content) {
        self.content = content
    }
    
    @Environment(\.refresh) private var refreshAction: RefreshAction?
    @EnvironmentObject private var chatLayout: ChatLayout
    @EnvironmentObject private var datasource: ChatDatasource
    
    @StateObject private var moreLoader = MoreLoader()
    private let timeSpacer = TimeSpacer()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollView in
                ScrollView(showsIndicators: false) {
                    
                    content((scrollView, geometry))
                        .overlay(progressView, alignment: .top)
                        .anchorPreference(key: ChatScrollViewPreferences.Key.self, value: .bounds) {
                            guard timeSpacer.canreturn else { return nil}
                            return .init(loaclFrame: geometry[$0], globalSize: geometry.size)
                        }
                        .onPreferenceChange(ChatScrollViewPreferences.Key.self) { obj in
                            guard let obj = obj else { return }
                            chatLayout.positions.cached = (obj.loaclFrame, obj.globalSize)
                            moreLoader.scrollDetector.send(obj)
                        }
                        .onReceive(moreLoader.scrollPublisher) { data in
                            if moreLoader.state == .None && (0.0...5.0).contains(data.offsetY) {
                                Task {
                                    moreLoader.state = .Loaded
                                    guard let firstId = datasource.msgs.first?.id else { return }
                                    await ToneManager.shared.playSound(tone: .Tock)
                                    await refreshAction?()
                                    await ToneManager.shared.vibrate(vibration: .rigid)
                                    scrollView.scrollTo(firstId, anchor: .top)
                                    moreLoader.state = .None
                                    scrollView.scrollTo(firstId, anchor: .top)
                                }
                            }
                        }
                    
                }
                
            }
        }
    }
    
    
    private var progressView: some View {
        Group {
            if moreLoader.state == .Loaded {
                VStack {
                    ProgressView()
                        .padding()
                }
            }
        }
    }
}
