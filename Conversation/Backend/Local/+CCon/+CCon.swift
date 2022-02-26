//
//  +CCon.swift
//  Conversation
//
//  Created by Aung Ko Min on 27/2/22.
//


import CoreData

extension CCon {
    
    class func create(id: String) {
        let context = Persistence.shared.context
        let cCon = CCon(context: context)
        cCon.id = id
        cCon.date = Date()
        cCon.name = Lorem.fullName
        do {
            try context.save()
        }catch {
            print(error)
        }
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
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do {
            return try context.fetch(request)
        }catch {
            print(error.localizedDescription)
            return []
        }
    }
}

extension CCon {
    
    var msgsCount: Int {
        CMsg.count(for: id ?? "")
    }
    
    var lastMsg: Msg {
        if let cMsg = CMsg.lastMsg(for: self) {
            return Msg(cMsg: cMsg)
        } else {
            return Msg(conId: UUID().uuidString, textData: .init(text: String()), rType: .Send, progress: .Read)
        }
    }
}
