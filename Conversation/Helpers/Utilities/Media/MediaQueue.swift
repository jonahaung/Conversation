//
//  MediaQueue.swift
//  Conversation
//
//  Created by Aung Ko Min on 17/2/22.
//

import Foundation
import CoreData

extension MediaQueue {
    
    class func fetch(id: String) -> MediaQueue? {
        let context = Persistence.shared.context
        let request = NSFetchRequest<MediaQueue>.init(entityName: MediaQueue.entity().name!)
        request.fetchLimit = 1
        request.predicate = .init(format: "id == %@", id)
        do {
            let results = try context.fetch(request)
            return results.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    class func fetchOne() -> MediaQueue? {
        let context = Persistence.shared.context
        let request = NSFetchRequest<MediaQueue>.init(entityName: MediaQueue.entity().name!)
        request.predicate = NSPredicate(format: "isQueued == %@", NSNumber(value: true))
        request.fetchLimit = 1
        do {
            let results = try context.fetch(request)
            return results.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    class func create(id: String) -> MediaQueue {
        let context = Persistence.shared.context
        let mediaQueue = MediaQueue(context: context)
        mediaQueue.id = id
        
        Persistence.shared.save()
        return mediaQueue
    }
    
    class func create(_ msg: Msg) {
        _ = MediaQueue.create(id: msg.id)
    }
    
    class func restart(_ id: String) {
        
        if let mediaQueue = MediaQueue.fetch(id: id) {
            mediaQueue.update(isFailed: false)
        }
        if let cMsg = CMsg.msg(for: id) {
            cMsg.progress = Msg.MsgProgress.SendingFailed.rawValue
        }
    }
}


extension MediaQueue {
    
    func update(isQueued value: Bool) {
        if (isQueued != value) {
            isQueued = value
            update()
        }
    }
    
    func update(isFailed value: Bool) {
        
        if (isFailed != value) {
            isFailed = value
            update()
        }
    }
    private func update() {
        Persistence.shared.save()
    }
}
