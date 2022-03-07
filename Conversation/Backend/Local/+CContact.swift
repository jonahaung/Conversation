//
//  +CContact.swift
//  Conversation
//
//  Created by Aung Ko Min on 7/3/22.
//

import CoreData

extension CContact {
    
    var conId: String {
        guard let id = self.id else { fatalError() }
        return id > CurrentUser.shared.user.id ? CurrentUser.shared.user.id + id : id + CurrentUser.shared.user.id
    }
    func con() -> Con {
        let conId = self.conId
        if let cCon = CCon.cCon(for: conId), Con(cCon: cCon).lastMsg() != nil  {
            return Con(cCon: cCon)
        } else {
            let cCon = CCon.fetchOrCreate(contact: self)
            return Con(cCon: cCon)
        }
    }
    
    
    
    convenience init(phContact: PhoneContact) {
        self.init(context: Persistence.shared.context)
        self.id = phContact.phoneNumber.first ?? ""
        self.name = phContact.name ?? ""
        self.phoneNumber = phContact.phoneNumber.first ?? ""
        if let data = phContact.avatarData {
            Media.save(userId: phContact.id, data: data)
        }
    }
    
    class func find(for id: String) -> CContact? {
        let context = Persistence.shared.context
        let request: NSFetchRequest<CContact> = CContact.fetchRequest()
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
    
    class func fecthOrCreate(for phoneContact: PhoneContact) -> CContact {
        if hasSaved(for: phoneContact.id), let x = find(for: phoneContact.id) {
            return x
        } else {
            return CContact(phContact: phoneContact)
        }
    }
    
    class func hasSaved(for id: String) -> Bool {
        let context = Persistence.shared.context
        let request: NSFetchRequest<CContact> = CContact.fetchRequest()
        request.resultType = .countResultType
        request.fetchLimit = 1
        request.predicate = .init(format: "id == %@", id)
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    class func fecthAll() -> [CContact] {
        let context = Persistence.shared.context
        let request: NSFetchRequest<CContact> = CContact.fetchRequest()
//        request.predicate = .init(format: "id == %@", id)
        do {
            let results = try context.fetch(request)
            return results
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    class func delete(cContact: CContact) {
        Persistence.shared.context.delete(cContact)
    }

}
