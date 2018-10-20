//
// Created by Tobias Brander on 2018-10-14.
// Copyright (c) 2018 Tobias Brander. All rights reserved.
//

import Foundation
import Library
import Contacts

class CNGroupViewModel: TableViewCellViewModel<CNGroup, UITableViewCell> {
    override func configure(cell: UITableViewCell, withModel model: CNGroup) {
        cell.textLabel?.text = model.name
        cell.accessoryType = .disclosureIndicator
    }
}
