//
//  InBoxManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 27/2/22.
//

import Foundation
import SwiftUI

class InBoxManager: ObservableObject {
    
    @Published var cons = [Con]()
    private var hasLoaded = false
    
    func fetch() {
        withAnimation {
            self.cons = CCon.cons().map(Con.init)
        }
    }
}
