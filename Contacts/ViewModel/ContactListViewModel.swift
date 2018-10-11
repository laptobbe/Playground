//
// Created by Tobias Brander on 2018-10-08.
// Copyright (c) 2018 Tobias Brander. All rights reserved.
//

import Foundation
import Library
import Contacts

final class ContactListViewModel : ViewModel, Injectable {
    static let id: String = UUID().uuidString

    let contactsRepository:ContactsRepository = Injection.singleton()

    lazy var contacts:Observable<[CNContact]> = {
        return wrapObservable(observable: contactsRepository.contacts)
    }()
}
