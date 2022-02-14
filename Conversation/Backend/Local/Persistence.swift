//
//  Persistence.swift
//  Temp
//
//  Created by Aung Ko Min on 13/2/22.
//

import CoreData

class PersistenceController {
    
    static let shared = PersistenceController()
    private let container: NSPersistentCloudKitContainer
    
    lazy var context: NSManagedObjectContext = { [unowned container] in
        return container.newBackgroundContext()
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Conversation")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
//        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func create(msg: Msg) -> CMsg {
        let context = self.context
        let cMsg = CMsg(context: context)
        cMsg.id = msg.id
        cMsg.conId = msg.conId
        cMsg.rType = Int16(msg.rType.rawValue)
        cMsg.msgType = Int16(msg.msgType.rawValue)
        cMsg.progress = Int16(msg.progress.rawValue)
        cMsg.date = msg.date
        cMsg.data = msg.textData?.text ?? msg.imageData?.urlString ?? msg.emojiData?.emojiID
        cMsg.lat = msg.locationData?.location.latitude ?? 0
        cMsg.long = msg.locationData?.location.longitude ?? 0
        cMsg.senderID = msg.sender.id
        cMsg.senderName = msg.sender.name
        cMsg.senderURL = msg.sender.photoURL
        cMsg.imageRatio = msg.imageRatio
        return cMsg
    }
    func cMsgsCount(conId: String) -> Int {
        let request = NSFetchRequest<CMsg>.init(entityName: CMsg.entity().name!)
        request.predicate = NSPredicate(format: "conId == %@", conId)
        request.resultType = .countResultType
        return (try? context.count(for: request)) ?? 0
    }
    
    func cMsgs(conId: String, limit: Int, offset: Int) -> [CMsg] {
        let request = NSFetchRequest<CMsg>.init(entityName: CMsg.entity().name!)
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
    func fetch(id: String) -> CMsg? {
        let request = NSFetchRequest<CMsg>.init(entityName: CMsg.entity().name!)
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
    
    func delete(id: String) {
        guard let cMsg = fetch(id: id) else { return }
        context.delete(cMsg)
    }
    
    func save() {
        let context = self.context
        if context.hasChanges {
            do {
                try context.save()
                Log("Saved")
            }catch {
                print(error.localizedDescription)
            }
        }
    }
}
