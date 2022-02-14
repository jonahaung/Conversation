//
//  PhotoLibrary.swift
//  Conversation
//
//  Created by Aung Ko Min on 14/2/22.
//

import SwiftUI

public struct PhotoLibrary: UIViewControllerRepresentable {

    @Binding var image: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = context.coordinator
        return controller
    }
    
    public func updateUIViewController(_: UIImagePickerController, context _: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public  class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        private let parent: PhotoLibrary
        
        public init(_ parent: PhotoLibrary) {
            self.parent = parent
        }
        
        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage ?? info[.editedImage] as? UIImage{
                parent.image = image
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

