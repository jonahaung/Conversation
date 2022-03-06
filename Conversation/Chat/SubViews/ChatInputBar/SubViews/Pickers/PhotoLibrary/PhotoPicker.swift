//
//  PhotoLibrary.swift
//  Conversation
//
//  Created by Aung Ko Min on 13/2/22.
//

import SwiftUI

struct PhotoPicker: View {
    
    let onSendPhoto: (UIImage) -> Void
    
    @State private var pickedImage: UIImage?
    @State private var shwoPicker = false
    
    var body: some View {
        InputPicker {
            Group {
                if let pickedImage = pickedImage {
                    Image(uiImage: pickedImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    Button("Pick") {
                        shwoPicker = true
                    }
                }
            }
            .sheet(isPresented: $shwoPicker) {
                PhotoLibrary(image: $pickedImage, showPicker: $shwoPicker)
            }
        } onSend: {
            guard let pickedImage = pickedImage else {
                return
            }
            self.pickedImage = nil
            onSendPhoto(pickedImage)
        }
    }
}
