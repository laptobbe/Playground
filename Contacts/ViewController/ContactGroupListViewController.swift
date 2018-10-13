//
// Created by Tobias Brander on 2018-10-13.
// Copyright (c) 2018 Tobias Brander. All rights reserved.
//

import Foundation
import UIKit
import Library
import Contacts

class ContactGroupListViewController : UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource:GroupsTableViewSource!
    private let viewModel:ContactGroupListViewModel = Injection.singleton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupViewModel()
    }

    private func setupTableView() {
        self.dataSource = GroupsTableViewSource(delegate: { (group) in
            
        })
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
    }

    private func setupViewModel() {
        viewModel.groups.observe({ (type: [CNGroup]) in
            self.dataSource.data = type
            self.tableView.reloadData()
        }, errorObserver: { error in

        })
    }

    private class GroupsTableViewSource : ArrayTableViewDataSource<CNGroup> {
        override func tableView(_ tableView: UITableView, cellForElement element: CNGroup, atIndexPath indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = element.name
            return cell
        }
    }
}
