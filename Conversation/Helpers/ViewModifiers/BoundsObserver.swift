//
//  BoundsObserver.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

extension View {
    public func saveBounds(viewId: AnyHashable, coordinateSpace: CoordinateSpace = .global) -> some View {
        background(GeometryReader { proxy in
            Color.clear.preference(key: SaveBoundsPrefKey.self, value: [SaveBoundsPrefData(viewId: viewId, bounds: proxy.frame(in: coordinateSpace))])
        })
    }
    
    public func retrieveBounds(viewId: AnyHashable, _ rect: Binding<CGRect>) -> some View {
        onPreferenceChange(SaveBoundsPrefKey.self) { preferences in
            DispatchQueue.main.async {
                let p = preferences.first(where: { $0.viewId == viewId })
                if let p = p {
                    rect.wrappedValue = p.bounds
                }
            }
        }
    }
    
    public func saveSize(viewId: String?, coordinateSpace: CoordinateSpace = .local) -> some View {
        Group {
            if let viewId = viewId {
                background(
                    GeometryReader { proxy in
                        Color.clear.preference(key: SaveSizePrefKey.self, value: [SaveSizePrefData(viewId: viewId, size: proxy.size)])
                    }
                )
            } else {
                self
            }
        }
    }
    
    public func retrieveSize(viewId: String?, _ rect: Binding<CGSize?>) -> some View {
        Group {
            if let viewId = viewId {
                onPreferenceChange(SaveSizePrefKey.self) { preferences in
                    DispatchQueue.main.async {
                        guard let preferences = preferences else {
                            return
                        }
                        let p = preferences.first(where: { $0.viewId == viewId })
                        rect.wrappedValue = p?.size
                    }
                }
            } else {
                self
            }
        }
    }
}

struct SaveBoundsPrefData: Equatable {
    let viewId: AnyHashable
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
    static var defaultValue: [SaveSizePrefData]? = nil
    
    static func reduce(value: inout [SaveSizePrefData]?, nextValue: () -> [SaveSizePrefData]?) {
        guard let next = nextValue() else { return }
        value?.append(contentsOf: next)
    }
    
    typealias Value = [SaveSizePrefData]?
}
