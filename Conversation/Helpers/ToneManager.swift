//
//  ToneManager.swift
//  MyBike
//
//  Created by Aung Ko Min on 20/12/21.
//

import Foundation
import UIKit
import AudioToolbox

enum AlertTones: SystemSoundID {
    
    case MailSent = 1001
    case MailReceived = 1000
    case receivedMessage = 1003
    case sendMessage = 1004
    case Tock = 1105
    case Typing = 1305
}

enum Vibration {
    case error
    case success
    case warning
    case light
    case medium
    case heavy
    case selection
    case oldSchool
    case rigid
    case soft
    func vibrate() {
        
        switch self {
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        case .oldSchool:
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        case .rigid:
            let generator = UIImpactFeedbackGenerator(style: .rigid)
            generator.impactOccurred()
        case .soft:
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        }
        
    }
    
}


actor ToneManager {

    static let shared = ToneManager()
    
    func playSound(tone: AlertTones) {
        AudioServicesPlaySystemSound(tone.rawValue)
    }

    func vibrate(vibration: Vibration) {
        vibration.vibrate()
    }
}
