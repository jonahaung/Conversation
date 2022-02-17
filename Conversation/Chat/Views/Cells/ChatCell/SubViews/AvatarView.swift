//
//  AvatarView.swift
//  Conversation
//
//  Created by Aung Ko Min on 17/2/22.
//

import SwiftUI

struct AvatarView: View {
    
    @State private var image: UIImage?
    @StateObject private var imageLoader = ImageLoaderCache.shared.loaderFor(path: "https://avatars.githubusercontent.com/u/20325472?v=4", imageSize: .medium)
    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                
            }else {
                ProgressView()
            }
        }
    }
}
