//
//  ImageService.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 07/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Combine
import UIKit

class ImageService {
    
    static let shared = ImageService()
    private let urlSession = URLSession.shared
    
    func fetchImage(_ url: URL, _ size: ImageSize) -> AnyPublisher<UIImage?, Never> {
        
        return urlSession.dataTaskPublisher(for: url)
            .tryMap { [weak self] (data, response) -> UIImage? in
                guard let image = UIImage(data: data) else {
                    return nil
                }
                return self?.resize(image, to: size.width)
            }.catch { _ in
                return Just(nil)
            }
            .eraseToAnyPublisher()
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



extension UIImage {
    var thumbnail: UIImage? {
        get async {
            let size = CGSize(width: 30, height: 30)
            return await self.byPreparingThumbnail(ofSize: size)
        }
    }
}
enum FetchError:Error{
    case badID
    case badImage
    
}
actor ImageDownloader {
    
    static let shared = ImageDownloader()
    private enum CacheEntry {
        case inProgress(Task<UIImage, Error>)
        case ready(UIImage)
    }
    
    private var cache: [URL: CacheEntry] = [:]
    
    func image(from url: URL) async throws -> UIImage? {
        if let cached = cache[url] {
            switch cached {
            case .ready(let image):
                return image
            case .inProgress(let handle):
                return try await handle.value
            }
        }
        
        let handle = Task {
            try await downloadImage(from: url)
        }
        
        cache[url] = .inProgress(handle)
        
        do {
            let image = try await handle.value
            cache[url] = .ready(image)
            return image
        } catch {
            cache[url] = nil
            throw error
        }
    }
    //URL.init(string:"https://www.apple.com/v/home/hc/images/overview/ios15_logo__cnpdxsz7otzm_large_2x.png")!)
    func downloadImage(from url:URL) async throws -> UIImage {
        let request = URLRequest.init(url:url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badID }
        let maybeImage = UIImage(data: data)
        guard let thumbnail = await maybeImage?.thumbnail else { throw FetchError.badImage }
        return  thumbnail
    }
}
