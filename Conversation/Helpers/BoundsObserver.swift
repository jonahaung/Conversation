//
//  BoundsObserver.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

extension View {
    public func saveBounds(viewId: String, color: Color = .clear, cornorRadius: CGFloat = 0, coordinateSpace: CoordinateSpace = .local) -> some View {
        background(GeometryReader { proxy in
            color.cornerRadius(cornorRadius).preference(key: SaveBoundsPrefKey.self, value: [SaveBoundsPrefData(viewId: viewId, bounds: proxy.frame(in: coordinateSpace))])
        })
    }
    
    public func retrieveBounds(viewId: String, _ rect: Binding<CGRect>) -> some View {
        onPreferenceChange(SaveBoundsPrefKey.self) { preferences in
            DispatchQueue.main.async {
                // The async is used to prevent a possible blocking loop,
                // due to the child and the ancestor modifying each other.
                let p = preferences.first(where: { $0.viewId == viewId })
                rect.wrappedValue = p?.bounds ?? .zero
            }
        }
    }
    public func saveSize(viewId: String?, coordinateSpace: CoordinateSpace = .global) -> some View {
        Group {
            if let viewId = viewId {
                background(GeometryReader { proxy in
                    Color.clear.preference(key: SaveSizePrefKey.self, value: [SaveSizePrefData(viewId: viewId, size: proxy.size)])
                })
            }else {
                background()
            }
        }
        
    }
    
    public func retrieveSize(viewId: String, _ rect: Binding<CGSize>) -> some View {
        onPreferenceChange(SaveSizePrefKey.self) { preferences in
            DispatchQueue.main.async {
                // The async is used to prevent a possible blocking loop,
                // due to the child and the ancestor modifying each other.
                let p = preferences.first(where: { $0.viewId == viewId })
                rect.wrappedValue = p?.size ?? .zero
            }
        }
    }
}

struct SaveBoundsPrefData: Equatable {
    let viewId: String
    let bounds: CGRect
}

struct SaveBoundsPrefKey: PreferenceKey {
    static var defaultValue: [SaveBoundsPrefData] = []
    
    static func reduce(value: inout [SaveBoundsPrefData], nextValue: () -> [SaveBoundsPrefData]) {
        value.append(contentsOf: nextValue())
    }
    
    typealias Value = [SaveBoundsPrefData]
}

struct SaveSizePrefData: Equatable {
    let viewId: String
    let size: CGSize
}

struct SaveSizePrefKey: PreferenceKey {
    static var defaultValue: [SaveSizePrefData] = []
    
    static func reduce(value: inout [SaveSizePrefData], nextValue: () -> [SaveSizePrefData]) {
        value.append(contentsOf: nextValue())
    }
    
    typealias Value = [SaveSizePrefData]
}
