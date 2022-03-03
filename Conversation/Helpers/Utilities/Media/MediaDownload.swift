//
//  MediaDownload.swift
//  Conversation
//
//  Created by Aung Ko Min on 17/2/22.
//


import UIKit
import FirebaseStorage
import FirebaseStorageCombineSwift
import FirebaseStorageSwift

class MediaDownload: NSObject {
    
    class func user(_ name: String, _ pictureAt: TimeInterval) async throws -> UIImage? {
        if (pictureAt != 0) {
            return try await UIImage(path: start("user", name, "jpeg", false))
        } else {
            throw NSError(domain: "Missing picture.", code: 100)
        }
    }
    
    class func photo(_ id: String) async throws -> String {
        return try await start("media", id, "jpeg", false)
    }
    
    class func video(_ id: String) async throws -> String {
        return try await start("media", id, "mp4", false)
    }
    
    class func audio(_ id: String) async throws -> String {
        return try await  start("media", id, "m4a", false)
    }
    
    
    private class func start(_ dir: String, _ id: String, _ ext: String, _ manual: Bool) async throws -> String {
        
        let file = "\(id).\(ext)"
        let path = Dir.document(dir, and: file)

        let fileManual = file + ".manual"
        let pathManual = Dir.document(dir, and: fileManual)

        let fileLoading = file + ".loading"
        let pathLoading = Dir.document(dir, and: fileLoading)

        // Check if file is already downloaded
        //---------------------------------------------------------------------------------------------------------------------------------------
        if (File.exist(path)) {
            return path
        }

        // Check if manual download is required
        //---------------------------------------------------------------------------------------------------------------------------------------
        if (manual) {
            if (File.exist(pathManual)) {
                throw NSError(domain: "Manual download required.", code: 101)
            }
            try "manual".write(toFile: pathManual, atomically: false, encoding: .utf8)
        }

        // Check if file is currently downloading
        //---------------------------------------------------------------------------------------------------------------------------------------
        let time = Int(Date().timeIntervalSince1970)

        if (File.exist(pathLoading)) {
            if let temp = try? String(contentsOfFile: pathLoading, encoding: .utf8) {
                if let check = Int(temp) {
                    if (time - check < 60) {
                        throw NSError(domain: "Already downloading.", code: 102)
                    }
                }
            }
        }
        try "\(time)".write(toFile: pathLoading, atomically: false, encoding: .utf8)

        
        let key = "\(dir)/\(id).\(ext)"
        
        let reference = Storage.storage().reference(withPath: key)
        let localURL = URL(string: "path/to/image")!
        
        let url = try await reference.writeAsync(toFile: localURL)
        
        File.remove(pathLoading)
        let data = Data(path: url.path)
        data?.write(path: path, options: .atomic)
        return path
    }
}
