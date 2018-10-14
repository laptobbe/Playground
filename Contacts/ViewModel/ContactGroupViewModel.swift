//
// Created by Tobias Brander on 2018-10-14.
// Copyright (c) 2018 Tobias Brander. All rights reserved.
//

import Foundation
import Library
import Contacts

class ContactGroupViewModel : ViewModel {
    var group:CNGroup!

    private let contactsRepository:ContactsRepository = Injection.singleton(type: ContactsRepositoryImpl.self)

    lazy var contacts:Observable<[CNContact]> = {
        wrapObservable(observable: contactsRepository.contacts(group: group))
    }()
}