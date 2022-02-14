//
//  PhotoLibrary.swift
//  Conversation
//
//  Created by Aung Ko Min on 13/2/22.
//

import SwiftUI

struct PhotoPicker: View {
    
    let onSendPhoto: (UIImage) async -> Void
    
    @State private var pickedImage: UIImage?
    @State private var showCamera = false
    @EnvironmentObject private var inputManager: ChatInputViewManager
    var body: some View {
        InputPicker {
            Group {
                if let pickedImage = pickedImage {
                    Image(uiImage: pickedImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    Divider()
                        .task {
                            showCamera = true
                        }
                }
            }
            .fullScreenCover(isPresented: $showCamera) {
                if pickedImage == nil {
                    inputManager.currentInputItem = .Text
                }
            } content: {
                PhotoLibrary(image: $pickedImage)
                    .edgesIgnoringSafeArea(.all)
            }
        } onSend: {
            guard let pickedImage = pickedImage else {
                return
            }

            await onSendPhoto(pickedImage)
            self.pickedImage = nil
        }
        
    }
}
