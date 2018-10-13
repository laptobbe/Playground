//
// Created by Tobias Brander on 2018-10-13.
// Copyright (c) 2018 Tobias Brander. All rights reserved.
//

import Foundation
import Library
import Contacts

class ContactGroupListViewModel : ViewModel {
    private let groupsRepository:GroupsRepository = Injection.singleton(type: GroupsRepositoryImpl.self)

    lazy var groups:Observable<[CNGroup]> = {
        return wrapObservable(observable: groupsRepository.groups)
    }()
}
