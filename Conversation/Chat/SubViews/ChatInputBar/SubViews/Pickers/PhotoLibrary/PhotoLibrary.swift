//
//  PhotoLibrary.swift
//  Conversation
//
//  Created by Aung Ko Min on 14/2/22.
//

import SwiftUI

public struct PhotoLibrary: UIViewControllerRepresentable {

    @Binding var image: UIImage?
    @Binding var showPicker: Bool
    
    
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
            DispatchQueue.main.async {
                if let image = info[.originalImage] as? UIImage ?? info[.editedImage] as? UIImage{
                    self.parent.image = self.resize(image, to: 250)
                    self.parent.showPicker = false
                }
            }
        }
        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showPicker = false
        }
        
        private func resize(_ image: UIImage, to width: CGFloat) -> UIImage {
            
            let oldWidth = image.size.width
            let scaleFactor = width / oldWidth
            
            let newHeight = image.size.height * scaleFactor
            let newWidth = oldWidth * scaleFactor
            
            let newSize = CGSize(width: newWidth, height: newHeight)

            return UIGraphicsImageRenderer(size: newSize).image { _ in
                image.draw(in: .init(origin: .zero, size: newSize))
            }
        }
    }
    
    
}

