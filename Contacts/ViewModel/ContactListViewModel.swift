//
// Created by Tobias Brander on 2018-10-08.
// Copyright (c) 2018 Tobias Brander. All rights reserved.
//

import Foundation
import Library
import Contacts

final class ContactListViewModel : ViewModel {
    var contactsRepository:ContactsRepository = Injection.singleton(type: ContactsRepositoryImpl.self)

    lazy var contacts:Observable<[CNContact]> = {
        return wrapObservable(observable: contactsRepository.contacts)
    }()
}
