//
//  CameraPicker.swift
//  Conversation
//
//  Created by Aung Ko Min on 14/2/22.
//

import SwiftUI

struct CameraPicker: View {
    
    let onSendPhoto: (UIImage) -> Void
    @EnvironmentObject private var inputManager: ChatInputViewManager
    @State private var pickedImage: UIImage?
    
    var body: some View {
        InputPicker {
            Group {
                if let pickedImage = pickedImage {
                    Image(uiImage: pickedImage)
                        .resizable()
                        .scaledToFit()
                        .padding()
                } else {
                    Camera(image: $pickedImage) {
                        inputManager.currentInputItem = .Text
                    }
                }
            }
        } onSend: {
            guard let pickedImage = pickedImage else {
                return
            }

            onSendPhoto(pickedImage)
            self.pickedImage = nil
        }
    }
}
