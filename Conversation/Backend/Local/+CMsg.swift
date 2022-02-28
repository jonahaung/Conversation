//
//  +CMsg.swift
//  Conversation
//
//  Created by Aung Ko Min on 27/2/22.
//

import Foundation
import CoreData

extension CMsg {
    
    class func create(msg: Msg) {
        let context = Persistence.shared.context
        let cMsg = CMsg(context: context)
        cMsg.id = msg.id
        cMsg.conId = msg.conId
        cMsg.rType = Int16(msg.rType.rawValue)
        cMsg.msgType = Int16(msg.msgType.rawValue)
        cMsg.progress = Int16(msg.progress.rawValue)
        cMsg.date = msg.date
        cMsg.data = msg.textData?.text ?? msg.attachmentData?.urlString ?? msg.emojiData?.emojiID
        cMsg.lat = msg.locationData?.longitude ?? 0
        cMsg.long = msg.locationData?.latitude ?? 0
        cMsg.senderID = msg.sender.id
        cMsg.senderName = msg.sender.name
        cMsg.senderURL = msg.sender.photoURL
        cMsg.imageRatio = msg.imageRatio
    }
    
    class func msg(for id: String) -> CMsg? {
        let context = Persistence.shared.context
        let request: NSFetchRequest<CMsg> = CMsg.fetchRequest()
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
    
    class func delete(id: String) {
        let context = Persistence.shared.context
        guard let cMsg = self.msg(for: id) else { return }
        context.delete(cMsg)
    }
    
    class func count(for conId: String) -> Int {
        let context = Persistence.shared.context
        let request: NSFetchRequest<CMsg> = CMsg.fetchRequest()
        request.predicate = NSPredicate(format: "conId == %@", conId)
        request.resultType = .countResultType
        return (try? context.count(for: request)) ?? 0
    }
    
    class func msgs(for conId: String, limit: Int, offset: Int) -> [CMsg] {
        let context = Persistence.shared.context
        context.refreshAllObjects()
        let request: NSFetchRequest<CMsg> = CMsg.fetchRequest()
        request.predicate = NSPredicate(format: "conId == %@", conId)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        request.fetchLimit = limit
        request.fetchOffset = offset
        do {
            return try context.fetch(request)
        }catch {
            print(error.localizedDescription)
            return []
        }
    }
    class func msgs(for conId: String) -> [CMsg] {
        let context = Persistence.shared.context
        let request: NSFetchRequest<CMsg> = CMsg.fetchRequest()
        request.predicate = NSPredicate(format: "conId == %@", conId)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            return try context.fetch(request)
        }catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    class func lastMsg(for conId: String) -> CMsg? {
        let context = Persistence.shared.context
        let request: NSFetchRequest<CMsg> = CMsg.fetchRequest()
        request.predicate = NSPredicate(format: "conId == %@", conId)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.fetchLimit = 1
        do {
            return try context.fetch(request).first
        }catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
