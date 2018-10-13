//
//  ContactsController.swift
//  Contacts
//
//  Created by Tobias Brander on 2018-10-08.
//  Copyright © 2018 Tobias Brander. All rights reserved.
//

import Foundation
import Library
import Contacts
import ContactsUI

protocol ContactsController : Injectable {
    func fetchContacts() -> Result<[CNContact]>
    func fetchGroups() -> Result<[CNGroup]>
}

final class ContactsControllerImpl: ContactsController {
    private let contactStore = CNContactStore()

    func fetchContacts() -> Result<[CNContact]> {
        let keys = [CNContact.descriptorForAllComparatorKeys(), CNContactViewController.descriptorForRequiredKeys()]
        let request = CNContactFetchRequest(keysToFetch: keys)
        var contacts = [CNContact]()
        do {
            try contactStore.enumerateContacts(with: request) { contact, pointer in
                contacts.append(contact)
            }
            return Result.success(contacts)
        } catch {
            return Result.error(error)
        }
    }

    func fetchGroups() -> Result<[CNGroup]> {
        do {
            return Result.success(try contactStore.groups(matching: nil))
        } catch {
            return Result.error(error)
        }

    }
}
