//
//  GrowingTextView.swift
//  GrowingTextView
//
//  Created by Xin Hong on 16/2/16.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit
import Combine

open class GrowingTextView: UIView {
    
    open weak var delegate: GrowingTextViewDelegate?

    open var internalTextView: UITextView {
        return textView
    }
    open var maxHeight: CGFloat? = 200
    open var minHeight: CGFloat = 0
    
    open var contentInset: UIEdgeInsets {
        guard let maxHeight = maxHeight else {
            return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 7)
        }

        if frame.height >= maxHeight {
            return UIEdgeInsets(top: textView.textContainerInset.top, left: 12, bottom: textView.textContainerInset.bottom, right: 7)
        } else {
            return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 7)
        }
    }
   
   
   
    // MARK: - UITextView properties
    /// The text displayed by the text view.
    open var text: String {
        set {
            textView.text = newValue
            updateHeight()
        }
        get {
            return textView.text ?? String()
        }
    }
   
    
    /// The current selection range of the receiver.
    open var selectedRange: NSRange? {
        set {
            if let newValue = newValue {
                textView.selectedRange = newValue
            }
        }
        get {
            return textView.selectedRange
        }
    }
    
    open var hasText: Bool {
        return textView.hasText
    }

    private let textView: GrowingInternalTextView = {
        $0.font = .systemFont(ofSize: UIFont.labelFontSize, weight: .regular)
        $0.textContainer.lineFragmentPadding = 1 // 1 pixel for caret
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = .zero
        $0.contentMode = .redraw
//        $0.backgroundColor = .secondarySystemGroupedBackground
        return $0
    }(GrowingInternalTextView())

    // MARK: - Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

// MARK: - Overriding
extension GrowingTextView {

    open override func layoutSubviews() {
        super.layoutSubviews()
        updateTextViewFrame()
        updateMinHeight()
        updateHeight()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = size
        if text.isEmpty {
            size.height = minHeight
        }
        return size
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.becomeFirstResponder()
    }

    open override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return textView.becomeFirstResponder()
    }

    open override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        return textView.resignFirstResponder()
    }

    open override var isFirstResponder: Bool {
        return textView.isFirstResponder
    }
}

// MARK: - Public
extension GrowingTextView {
    
    public func calculateHeight() -> CGFloat {
        return ceil(textView.sizeThatFits(textView.frame.size).height + contentInset.top + contentInset.bottom)
    }

    public func updateHeight() {
        let updatedHeightInfo = updatedHeight()
        let newHeight = updatedHeightInfo.newHeight
        let difference = updatedHeightInfo.difference

        if difference != 0 {
            updateGrowingTextView(newHeight: newHeight, difference: difference)
            if let delegate = delegate, delegate.responds(to: DelegateSelectors.didChangeHeight) {
                delegate.growingTextView!(self, didChangeHeight: newHeight, difference: difference)
            }
        }

        updateScrollPosition()
        textView.shouldDisplayPlaceholder = !textView.hasText
    }
}

// MARK: - Helper
extension GrowingTextView {
    fileprivate func commonInit() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 15
        textView.frame = CGRect(origin: .zero, size: frame.size)
        textView.delegate = self
        addSubview(textView)
        clipsToBounds = true
    }

    fileprivate func updateTextViewFrame() {
        let lineFragmentPadding = textView.textContainer.lineFragmentPadding
        var textViewFrame = frame
        textViewFrame.origin.x = contentInset.left - lineFragmentPadding
        textViewFrame.origin.y = contentInset.top
        textViewFrame.size.width -= contentInset.left + contentInset.right - lineFragmentPadding * 2
        textViewFrame.size.height -= contentInset.top + contentInset.bottom
        textView.frame = textViewFrame
        textView.sizeThatFits(textView.frame.size)
    }

    fileprivate func updateGrowingTextView(newHeight: CGFloat, difference: CGFloat) {
        if let delegate = delegate, delegate.responds(to: DelegateSelectors.willChangeHeight) {
            delegate.growingTextView!(self, willChangeHeight: newHeight, difference: difference)
        }
//        frame.size.height = newHeight
        updateTextViewFrame()
    }

    fileprivate func updatedHeight() -> (newHeight: CGFloat, difference: CGFloat) {
        var newHeight = calculateHeight()
        if newHeight < minHeight || !hasText {
            newHeight = minHeight
        }
        if let maxHeight = maxHeight, newHeight > maxHeight {
            newHeight = maxHeight
        }
        let difference = newHeight - frame.height

        return (newHeight, difference)
    }

    fileprivate func heightForNumberOfLines(_ numberOfLines: Int) -> CGFloat {
        var text = "-"
        if numberOfLines > 0 {
            for _ in 1..<numberOfLines {
                text += "\n|W|"
            }
        }
        let textViewCopy: GrowingInternalTextView = textView.copy() as! GrowingInternalTextView
        textViewCopy.text = text
        let height = ceil(textViewCopy.sizeThatFits(textViewCopy.frame.size).height + contentInset.top + contentInset.bottom)
        return height
    }
    fileprivate func updateMinHeight() {
        guard minHeight == 0 else { return }
        let textViewCopy: GrowingInternalTextView = textView.copy() as! GrowingInternalTextView
        textViewCopy.text = "-"
        minHeight = ceil(textViewCopy.sizeThatFits(textViewCopy.frame.size).height + contentInset.top + contentInset.bottom)
        delegate?.growingTextView?(self, didUpdateMinHeight: minHeight)
    }

    fileprivate func updateScrollPosition() {
        guard let selectedTextRange = textView.selectedTextRange else {
            return
        }
        let caretRect = textView.caretRect(for: selectedTextRange.end)
        let caretY = max(caretRect.origin.y + caretRect.height - textView.frame.height, 0)

        // Continuous multiple "\r\n" get an infinity caret rect, set it as the content offset will result in crash.
        guard caretY != CGFloat.infinity && caretY != CGFloat.greatestFiniteMagnitude else {
            print("Invalid caretY: \(caretY)")
            return
        }
        textView.setContentOffset(CGPoint(x: 0, y: caretY), animated: true)
    }
}

// MARK: - TextView delegate
extension GrowingTextView: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if let delegate = delegate, delegate.responds(to: DelegateSelectors.shouldBeginEditing) {
            return delegate.growingTextViewShouldBeginEditing!(self)
        }
        return true
    }

    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if let delegate = delegate, delegate.responds(to: DelegateSelectors.shouldEndEditing) {
            return delegate.growingTextViewShouldEndEditing!(self)
        }
        return true
    }

    public func textViewDidBeginEditing(_ textView: UITextView) {
        if let delegate = delegate, delegate.responds(to: DelegateSelectors.didBeginEditing) {
            delegate.growingTextViewDidBeginEditing!(self)
        }
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        if let delegate = delegate, delegate.responds(to: DelegateSelectors.didEndEditing) {
            delegate.growingTextViewDidEndEditing!(self)
        }
    }
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if !hasText && text == "" {
            return false
        }
        if !hasText && text == "\n" {
            textView.endEditing(true)
            return false
        }
        if let delegate = delegate, delegate.responds(to: DelegateSelectors.shouldChangeText) {
            return delegate.growingTextView!(self, shouldChangeTextInRange: range, replacementText: text)
        }
        return true
    }

    public func textViewDidChange(_ textView: UITextView) {
        updateHeight()
        if let delegate = delegate, delegate.responds(to: DelegateSelectors.didChange) {
            delegate.growingTextViewDidChange!(self)
        }
    }

    public func textViewDidChangeSelection(_ textView: UITextView) {
        let willUpdateHeight = updatedHeight().difference != 0
        if !willUpdateHeight {
            updateScrollPosition()
        }
        if let delegate = delegate, delegate.responds(to: DelegateSelectors.didChangeSelection) {
            delegate.growingTextViewDidChangeSelection!(self)
        }
    }
}
