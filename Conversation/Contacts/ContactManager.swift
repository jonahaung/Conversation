//
//  ContactManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 7/3/22.
//

import Contacts

class ContactManager: ObservableObject {
    
    var displayContacts: [CContact] {
        if searchText.isEmpty {
            return contacts
        }else {
            return contacts.filter{ ($0.name ?? "").lowercased().contains(searchText.lowercased()) }
        }
    }
    
    private var contacts = [CContact]()
    @Published var searchText = ""
    
    func task() {
        if contacts.isEmpty {
            loadContacts()
            objectWillChange.send()
        }
    }
    
    func delete(at offsets: IndexSet) {
        if let first = offsets.first {
            let con =  displayContacts[first]
            CContact.delete(cContact: con)
            contacts.remove(atOffsets: offsets)
            objectWillChange.send()
        }
    }
    
    fileprivate func loadContacts() {
        contacts.removeAll()
        for contact in ContactManager.getContacts() {
            let cContact = CContact.fecthOrCreate(for: PhoneContact(contact: contact))
            contacts.appendUnique(cContact)

        }
    }
    
    class func getContacts() -> [CNContact] { //  ContactsFilter is Enum find it below
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactThumbnailImageDataKey] as [Any]
        
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        var results: [CNContact] = []
        
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching containers")
            }
        }
        return results
    }
}
