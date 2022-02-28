//
//  SlidingDatasource(.swift
//  Conversation
//
//  Created by Aung Ko Min on 28/2/22.
//

import Foundation
public enum InsertPosition {
    case top
    case bottom
}

public class SlidingDataSource<Element: Equatable> {

    private var pageSize: Int
    private var windowOffset: Int
    private var windowCount: Int
    private var itemGenerator: (() -> Element)?
    private var items = [Element]()
    private var itemsOffset: Int
    
    public var itemsInWindow: [Element] {
        let offset = self.windowOffset - self.itemsOffset
        return Array(items[offset..<offset+self.windowCount])
    }

    public init(count: Int, pageSize: Int, itemGenerator: (() -> Element)?) {
        self.windowOffset = count
        self.itemsOffset = count
        self.windowCount = 0
        self.pageSize = pageSize
        self.itemGenerator = itemGenerator
        self.generateItems(min(pageSize, count), position: .top)
    }

    public convenience init(items: [Element], pageSize: Int) {
        var iterator = items.makeIterator()
        self.init(count: items.count, pageSize: pageSize) { iterator.next()! }
    }

    private func generateItems(_ count: Int, position: InsertPosition) {
        guard count > 0 else { return }
        guard let itemGenerator = self.itemGenerator else {
            fatalError("Can't create messages without a generator")
        }
        for _ in 0..<count {
            self.insertItem(itemGenerator(), position: position)
        }
    }

    public func insertItem(_ item: Element, position: InsertPosition) {
        if position == .top {
            self.items.insert(item, at: 0)
            let shouldExpandWindow = self.itemsOffset == self.windowOffset
            self.itemsOffset -= 1
            if shouldExpandWindow {
                self.windowOffset -= 1
                self.windowCount += 1
            }
        } else {
            let shouldExpandWindow = self.itemsOffset + self.items.count == self.windowOffset + self.windowCount
            if shouldExpandWindow {
                self.windowCount += 1
            }
            self.items.append(item)
        }
    }

    public func remove(msg: Element) {
        guard let index = self.items.firstIndex(of: msg) else { return }
        let shouldShrinkWindow = self.itemsOffset + self.items.count == self.windowOffset + self.windowCount
        if shouldShrinkWindow {
            self.windowCount -= 1
        }
        self.items.remove(at: index)
    }

    public func hasPrevious() -> Bool {
        return self.windowOffset > 0
    }

    public func hasMore() -> Bool {
        return self.windowOffset + self.windowCount < self.itemsOffset + self.items.count
    }

    public func loadPrevious() {
        let previousWindowOffset = self.windowOffset
        let previousWindowCount = self.windowCount
        let nextWindowOffset = max(0, self.windowOffset - self.pageSize)
        let messagesNeeded = self.itemsOffset - nextWindowOffset
        if messagesNeeded > 0 {
            self.generateItems(messagesNeeded, position: .top)
        }
        let newItemsCount = previousWindowOffset - nextWindowOffset
        self.windowOffset = nextWindowOffset
        self.windowCount = previousWindowCount + newItemsCount
    }

    public func loadNext() {
        guard self.items.count > 0 else { return }
        let itemCountAfterWindow = self.itemsOffset + self.items.count - self.windowOffset - self.windowCount
        self.windowCount += min(self.pageSize, itemCountAfterWindow)
    }

    @discardableResult
    public func adjustWindow(focusPosition: Double, maxWindowSize: Int) -> Bool {
        assert(0 <= focusPosition && focusPosition <= 1, "")
        guard 0 <= focusPosition && focusPosition <= 1 else {
            assert(false, "focus should be in the [0, 1] interval")
            return false
        }
        let sizeDiff = self.windowCount - maxWindowSize
        guard sizeDiff > 0 else { return false }
        self.windowOffset +=  Int(focusPosition * Double(sizeDiff))
        self.windowCount = maxWindowSize
        return true
    }

    @discardableResult
    func replaceItem(withNewItem item: Element, where predicate: (Element) -> Bool) -> Bool {
        guard let index = self.items.firstIndex(where: predicate) else { return false }
        self.items[index] = item
        return true
    }
}
