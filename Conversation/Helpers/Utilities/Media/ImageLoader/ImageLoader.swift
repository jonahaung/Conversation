//
//  ImageData.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Combine

class ImageLoaderCache {
    
    static let shared = ImageLoaderCache()
    
    private var loaders: NSCache<NSString, ImageLoader> = NSCache()
    
    func loaderFor(path: String, imageSize: ImageSize) -> ImageLoader {
        let key = NSString(string: path + "\(imageSize)")
        if let loader = loaders.object(forKey: key) {
            return loader
        } else {
            let loader = ImageLoader(path, imageSize)
            loaders.setObject(loader, forKey: key)
            return loader
        }
    }
}
enum ImageSize {

    case small, medium, large
    case custom(CGFloat)
    
    var width: CGFloat {
        switch self {
        case .small: return 15
        case .medium: return 40
        case .large: return 80
        case .custom(let x): return x }
    }
}

final class ImageLoader: ObservableObject {
    
    public let urlString: String?
    private let posterSize: ImageSize
    @Published public var image: UIImage?
    
    public var objectWillChange: AnyPublisher<UIImage?, Never> = Publishers.Sequence<[UIImage?], Never>(sequence: []).eraseToAnyPublisher()
    public var cancellable: AnyCancellable?
    
    public init(_ urlString: String?, _ posterSize: ImageSize) {
        self.posterSize = posterSize
        self.urlString = urlString
        
        objectWillChange = $image.handleEvents(receiveSubscription: { _ in
            self.loadImage()
        }, receiveCancel: {
            self.cancellable?.cancel()
        }).eraseToAnyPublisher()
    }
    
    private func loadImage() {
        
        guard image == nil else { return }
        
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        
        cancellable = ImageService.shared.fetchImage(url, posterSize)
            .receive(on: DispatchQueue.main)
            .assign(to: \ImageLoader.image, on: self)
    }
    
    deinit {
        cancellable?.cancel()
    }
}
