//
//  MediaDownload.swift
//  Conversation
//
//  Created by Aung Ko Min on 17/2/22.
//


import UIKit
import FirebaseStorage
import FirebaseStorageCombineSwift

class MediaDownload: NSObject {
    
    class func user(_ name: String, _ pictureAt: TimeInterval) async throws -> UIImage? {
        if (pictureAt != 0) {
            return try await UIImage(path: start("user", name, "jpg", false))
        } else {
            throw NSError(domain: "Missing picture.", code: 100)
        }
    }
    
    class func photo(_ name: String) async throws -> String {
        return try await start("media", name, "jpg", true)
    }
    
    class func video(_ name: String) async throws -> String {
        return try await start("media", name, "mp4", true)
    }
    
    class func audio(_ name: String) async throws -> String {
        return try await  start("media", name, "m4a", true)
    }
    
    
    private class func start(_ dir: String, _ name: String, _ ext: String, _ manual: Bool) async throws -> String {
        
        let file = "\(name).\(ext)"
        let path = Dir.document(dir, and: file)
        
        let fileManual = file + ".manual"
        let pathManual = Dir.document(dir, and: fileManual)
        
        let fileLoading = file + ".loading"
        let pathLoading = Dir.document(dir, and: fileLoading)
        
        if (File.exist(path)) {
            return path
        }
        
        if (manual) {
            if (File.exist(pathManual)) {
                throw NSError(domain: "Manual download required.", code: 101)
            }
            try? "manual".write(toFile: pathManual, atomically: false, encoding: .utf8)
        }
        
        
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
        try? "\(time)".write(toFile: pathLoading, atomically: false, encoding: .utf8)
        
        let key = "\(dir)/\(name).\(ext)"
        let storage = Storage.storage().reference(withPath: key)
        let url = try await storage.writeAsync(toFile: URL(fileURLWithPath: path))
        let data = Data(path: url.path)
        data?.write(path: path, options: .atomic)
        return path
    }
}
