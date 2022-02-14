//
//  PhotoLibrary.swift
//  Conversation
//
//  Created by Aung Ko Min on 13/2/22.
//

import SwiftUI
import UI

struct PhotoPicker: View {
    
    let onSendPhoto: (UIImage) async -> Void
    
    @State private var pickedImage: UIImage?
    
    var body: some View {
        InputPicker {
            VStack {
                if let image = pickedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("Select image from library")
                        .tapToPresent(
                            ImagePickerSingle(autoDismiss: true) { image in
                                withAnimation(.interactiveSpring()) {
                                    self.pickedImage = image
                                }
                            }
                        )
                }
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
