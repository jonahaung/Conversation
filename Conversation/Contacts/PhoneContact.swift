//
//  Contact.swift
//  Conversation
//
//  Created by Aung Ko Min on 7/3/22.
//

import Contacts

class PhoneContact: ObservableObject, Identifiable {
    
    var id: String { phoneNumber.first ?? ""}
    var name: String?
    var avatarData: Data?
    var phoneNumber: [String] = [String]()
    var email: [String] = [String]()
    
    init(contact: CNContact) {
        name = contact.givenName + " " + contact.familyName
        avatarData = contact.thumbnailImageData
        for phone in contact.phoneNumbers {
            if phone.label == CNLabelPhoneNumberMobile {
                let numberValue = phone.value
                if
                    //                    let countryCode = numberValue.value(forKey: "countryCode") as? String,
                    let digits = numberValue.value(forKey: "digits") as? String {
                    phoneNumber.append(digits)
                }
                phoneNumber.append(phone.value.stringValue)
            }
        }
        for mail in contact.emailAddresses {
            email.append(mail.value as String)
        }
    }
   
    func cContact() -> CContact {
        return CContact.fecthOrCreate(for: self)
    }
}
