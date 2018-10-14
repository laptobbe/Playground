//
// Created by Tobias Brander on 2018-10-14.
// Copyright (c) 2018 Tobias Brander. All rights reserved.
//

import Foundation
import Library
import Contacts

class ContactsListTableViewSource : ArrayTableViewDataSource<CNContact> {
    private let cellIdentifier:String

    init(data: [CNContact] = [], cellIdentifier: String, delegate: ArrayTableViewDataSourceDelegate? = nil) {
        self.cellIdentifier = cellIdentifier
        super.init(data: data, delegate: delegate)
    }

    override func tableView(_ tableView: UITableView, cellForElement element: CNContact, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.textLabel?.text = element.givenName
        return cell
    }
}