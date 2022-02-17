//
//  ImageBubble.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct ImageBubble: View {
    
    @EnvironmentObject internal var msg: Msg
    
    
    var body: some View {
        Group {
            if let path = Media.path(photoId: msg.id), let image = UIImage(path: path) {
                Image(uiImage: resize(image, to: ChatKit.mediaMaxWidth))
                    .resizable()
                    .cornerRadius(8)
                    .tapToPresent(ImageViewer(image: image))
            } else {
                ZStack {
                    ProgressView()
                }
            }
        }
        .frame(width: ChatKit.mediaMaxWidth, height: ChatKit.mediaMaxWidth * 1/msg.imageRatio)
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
