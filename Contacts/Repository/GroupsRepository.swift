//
// Created by Tobias Brander on 2018-10-13.
// Copyright (c) 2018 Tobias Brander. All rights reserved.
//

import Foundation
import Library
import Contacts

protocol GroupsRepository : Injectable {
    var groups:Observable<[CNGroup]> { get }
}

final class GroupsRepositoryImpl : GroupsRepository {
    var contactsController:ContactsController = Injection.singleton(type:ContactsControllerImpl.self)

    lazy var groups:Observable<[CNGroup]> = {
        let observer = Observable<[CNGroup]>()
        func fetch() {
            DispatchQueue.global().async {
                let result = self.contactsController.fetchGroups()
                switch(result) {
                case .success(let contacts):
                    observer.value = contacts
                case .error(let error):
                    observer.error = error
                }
            }
        }

        fetch()
        NotificationCenter.default.addObserver(forName: NSNotification.Name.CNContactStoreDidChange, object: nil, queue:OperationQueue.main) { notification in
            fetch()
        }
        return observer
    }()

}