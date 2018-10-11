//
// Created by Tobias Brander on 2018-10-08.
// Copyright (c) 2018 Tobias Brander. All rights reserved.
//

import Foundation
import Library
import Contacts

final class ContactsRepository : Injectable {
    let contactsController:ContactsController = Injection.singleton()
    static var id: String = UUID().uuidString

    lazy var contacts:Observable<[CNContact]> = {
        let observer = Observable<[CNContact]>()
        func fetch() {
            DispatchQueue.global().async {
                let result = self.contactsController.fetchContacts()
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
