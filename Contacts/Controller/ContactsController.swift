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
    func fetchContacts(group:CNGroup) -> Result<[CNContact]>
    func fetchGroups() -> Result<[CNGroup]>
}

final class ContactsControllerImpl: ContactsController {
    private let contactStore = CNContactStore()

    private func _fetchContacts(group:CNGroup? = nil) -> Result<[CNContact]> {
        let keys = [CNContact.descriptorForAllComparatorKeys(), CNContactViewController.descriptorForRequiredKeys()]
        let request = CNContactFetchRequest(keysToFetch: keys)
        if let group = group {
            request.predicate = CNContact.predicateForContactsInGroup(withIdentifier: group.identifier)
        }
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

    func fetchContacts() -> Result<[CNContact]> {
        return _fetchContacts()
    }

    func fetchContacts(group: CNGroup) -> Result<[CNContact]> {
        return _fetchContacts(group: group)
    }
}
