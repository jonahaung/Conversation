//
//  +BgImage.swift
//  Conversation
//
//  Created by Aung Ko Min on 27/2/22.
//

import SwiftUI

extension CCon {
    
    var bgImage: BgImage {
        get {
            return BgImage(rawValue: bgImageIndext) ?? .Brown
        }
        set {
            bgImageIndext = newValue.rawValue
            Persistence.shared.save()
        }
    }
    
    enum BgImage: Int16, CaseIterable {
        
        case None, One, White, Blue, Brown
        
        var name: String { "chatBg\(rawValue)" }
        
        var image: some View {
            Image(name)
                .resizable()
                .clipped()
        }
    }
}
