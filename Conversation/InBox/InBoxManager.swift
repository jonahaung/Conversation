//
//  InBoxManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 27/2/22.
//

import Foundation
import SwiftUI

class InBoxManager: ObservableObject {
    
    @Published var cCons = CCon.cons()
    
    private var isFirstTime = true
    
    func update() {
        withAnimation(.interactiveSpring()) {
            cCons = CCon.cons()
        }
    }
    
    func refresh() {
        cCons.forEach {
            $0.objectWillChange.send()
        }
    }
    
    func onAppear() {
        if isFirstTime {
            isFirstTime = false
        } else {
            refresh()
            Persistence.shared.save()
        }
    }
}
