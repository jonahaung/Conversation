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
        
        try await start("user", name, "jpeg", data)
    }
    
    class func photo(_ name: String, _ data: Data) async throws {
        
        try await start("media", name, "jpeg", data)
    }
    
    class func video(_ name: String, _ data: Data) async throws {
        
        try await start("media", name, "mp4", data)
    }
    
    class func audio(_ name: String, _ data: Data) async throws {
        
        try await start("media", name, "m4a", data)
    }
    
    private class func start(_ dir: String, _ id: String, _ ext: String, _ data: Data) async throws {
        let key = "\(id).\(ext)"
        let storage = Storage.storage().reference().child(dir).child(key)
        let put = try await storage.putDataAsync(data)
        print(put)
    }
}
