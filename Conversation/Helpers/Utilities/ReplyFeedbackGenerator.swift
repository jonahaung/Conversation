//
//  ReplyFeedbackGenerator.swift
//  Conversation
//
//  Created by Aung Ko Min on 28/2/22.
//

import UIKit

public protocol ReplyFeedbackGeneratorProtocol {
    func generateFeedback()
}

public struct ReplyFeedbackGenerator: ReplyFeedbackGeneratorProtocol {

    static let shared = ReplyFeedbackGenerator()
    private let impactFeedbackGenerator: UIImpactFeedbackGenerator

    public init() {
        self.impactFeedbackGenerator = UIImpactFeedbackGenerator()
    }

    public func generateFeedback() {
        self.impactFeedbackGenerator.impactOccurred(intensity: 0.8)
    }
}
