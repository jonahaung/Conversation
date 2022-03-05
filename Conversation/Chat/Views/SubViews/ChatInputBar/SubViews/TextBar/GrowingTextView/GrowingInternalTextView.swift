//
//  GrowingInternalTextView.swift
//  GrowingTextView
//
//  Created by Xin Hong on 16/2/16.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit

internal class GrowingInternalTextView: UITextView, NSCopying {

    var shouldDisplayPlaceholder = true {
        didSet {
            if shouldDisplayPlaceholder != oldValue {
                setNeedsDisplay()
            }
        }
    }

    private let placeholder = NSAttributedString(string: "Text", attributes: [.font: UIFont.systemFont(ofSize: UIFont.labelFontSize), .foregroundColor: UIColor.opaqueSeparator])
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard shouldDisplayPlaceholder else { return }
        
        let xPosition: CGFloat = textContainer.lineFragmentPadding + textContainerInset.left
        let yPosition: CGFloat = (textContainerInset.top)
        let rect = CGRect(origin: CGPoint(x: xPosition, y: yPosition), size: placeholder.size())
        placeholder.draw(in: rect)
    }


    func copy(with zone: NSZone?) -> Any {
        let textView = GrowingInternalTextView(frame: frame)
        textView.isScrollEnabled = isScrollEnabled
        textView.shouldDisplayPlaceholder = shouldDisplayPlaceholder
        textView.text = text
        textView.font = font
        textView.textColor = textColor
        textView.textAlignment = textAlignment
        textView.isEditable = isEditable
        textView.selectedRange = selectedRange
        textView.dataDetectorTypes = dataDetectorTypes
        textView.returnKeyType = returnKeyType
        textView.keyboardType = keyboardType
        textView.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically
        textView.textContainerInset = textContainerInset
        textView.textContainer.lineFragmentPadding = textContainer.lineFragmentPadding
        textView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        textView.contentInset = contentInset
        textView.contentMode = contentMode

        return textView
    }
}
