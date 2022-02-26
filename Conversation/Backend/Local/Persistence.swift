//
//  Persistence.swift
//  Temp
//
//  Created by Aung Ko Min on 13/2/22.
//

import CoreData

class Persistence {
    
    static let shared = Persistence()
    class func setup() {
        _ = shared
    }
    
    private let container: NSPersistentCloudKitContainer
    
    lazy var context: NSManagedObjectContext = { [unowned container] in
        return container.newBackgroundContext()
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Conversation")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func save() {
        let context = self.context
        if context.hasChanges {
            do {
                try context.save()
            }catch {
                print(error.localizedDescription)
            }
        }
    }
}
