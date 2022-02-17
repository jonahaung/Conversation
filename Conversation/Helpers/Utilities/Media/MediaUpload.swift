//
//  MediaUpload.swift
//  Conversation
//
//  Created by Aung Ko Min on 17/2/22.
//

import Foundation
import FirebaseStorage
import FirebaseStorageCombineSwift

class MediaUpload: NSObject {
    
    class func user(_ name: String, _ data: Data) async throws {
        
        try await start("user", name, "jpg", data)
    }
    
    class func photo(_ name: String, _ data: Data) async throws {
        
        try await start("media", name, "jpg", data)
    }
    
    class func video(_ name: String, _ data: Data) async throws {
        
        try await start("media", name, "mp4", data)
    }
    
    class func audio(_ name: String, _ data: Data) async throws {
        
        try await start("media", name, "m4a", data)
    }
    
    private class func start(_ dir: String, _ name: String, _ ext: String, _ data: Data) async throws {
        
        let key = "\(name).\(ext)"
        let storage = Storage.storage().reference(withPath: dir).child(key)
        _ = try await storage.putDataAsync(data)
    }
}
