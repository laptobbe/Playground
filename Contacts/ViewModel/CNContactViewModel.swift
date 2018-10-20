//
// Created by Tobias Brander on 2018-10-14.
// Copyright (c) 2018 Tobias Brander. All rights reserved.
//

import Foundation
import Library
import Contacts

class CNContactViewModel: TableViewCellViewModel<CNContact, UITableViewCell> {
    override func configure(cell: UITableViewCell, withModel model: CNContact) {
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.textLabel?.text = model.givenName
    }
}
