//
//  +CCon.swift
//  Conversation
//
//  Created by Aung Ko Min on 27/2/22.
//


import CoreData

extension CCon {

    class func fetchOrCreate(contact: CContact) -> CCon {
        let conId = contact.conId
        if let cCon = cCon(for: conId) {
            return cCon
        }
        let cCon = create(id: conId)
        cCon.name = contact.name
        
        return cCon
    }
    @discardableResult
    class func create(id: String) -> CCon {
        let context = Persistence.shared.context
        let cCon = CCon(context: context)
        cCon.id = id
        cCon.date = Date()
        return cCon
    }
    
    class func cCon(for id: String) -> CCon? {
        let context = Persistence.shared.context
        let request: NSFetchRequest<CCon> = CCon.fetchRequest()
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
    
    class func delete(cCon: CCon) {
        Persistence.shared.context.delete(cCon)
    }
    
    class func cons() -> [CCon] {
        let context = Persistence.shared.context
        let request: NSFetchRequest<CCon> = CCon.fetchRequest()
        request.predicate = .init(format: "hasMsgs == %@", NSNumber(true))
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            return try context.fetch(request)
        }catch {
            print(error.localizedDescription)
            return []
        }
    }
    
}
