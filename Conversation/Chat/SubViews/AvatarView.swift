//
//  AvatarView.swift
//  Conversation
//
//  Created by Aung Ko Min on 17/2/22.
//

import SwiftUI
import Combine

struct AvatarView: View {
    let id: String
    public var cancellable: AnyCancellable?
    @StateObject private var imageLoader = ImageLoaderCache.shared.loaderFor(path: "https://avatars.githubusercontent.com/u/20325472?v=4", imageSize: .small)
    var body: some View {
        Group {
            if let path = Media.path(userId: id), let image = UIImage(path: path) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundStyle(.secondary)
                    .task {
                        if let image = imageLoader.image, let data = image.jpegData(compressionQuality: 0.7) {
                            Media.save(userId: id, data: data)
                        }
                    }
            }
        }
    }
}
