//
// Created by Tobias Brander on 2018-10-08.
// Copyright (c) 2018 Tobias Brander. All rights reserved.
//

import Foundation
import Library
import Contacts

protocol ContactsRepository : Injectable {
    var contacts:Observable<[CNContact]> { get }
    func contacts(group:CNGroup) -> Observable<[CNContact]>
}

final class ContactsRepositoryImpl : ContactsRepository {
    let contactsController:ContactsController = Injection.singleton(type:ContactsControllerImpl.self)

    private var groupObservables:[CNGroup:Observable<[CNContact]>] = [:]

    private func contactsRequestObserver(fetcher: @escaping ()->(Result<[CNContact]>)) -> Observable<[CNContact]> {
        let observer = Observable<[CNContact]>()
        func fetch() {
            DispatchQueue.global().async {
                let result = fetcher()
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
    }

    lazy var contacts:Observable<[CNContact]> = {
        return self.contactsRequestObserver { self.contactsController.fetchContacts() }
    }()

    func contacts(group:CNGroup) -> Observable<[CNContact]> {
        let observable = groupObservables[group] ?? self.contactsRequestObserver { self.contactsController.fetchContacts(group: group) }
        groupObservables[group] = observable
        return observable
    }
}
