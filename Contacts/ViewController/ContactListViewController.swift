//
//  ViewController.swift
//  Contacts
//
//  Created by Tobias Brander on 2018-10-08.
//  Copyright © 2018 Tobias Brander. All rights reserved.
//

import UIKit
import Library
import Contacts

class ContactListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    let viewModel:ContactListViewModel = Injection.new()
    let dataSource = ContactsListTableViewSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupViewModel()
    }

    private func setupTableView() {
        self.tableView.dataSource = dataSource
        self.tableView.delegate = dataSource
    }

    private func setupViewModel() {
        viewModel.contacts.observe({ (contacts) in
            self.dataSource.data = contacts
            self.tableView.reloadData()
        }, errorObserver: { error in
            print(error)
        })
    }
}

class ContactsListTableViewSource : ArrayTableViewDataSource<CNContact> {
    override func tableView(_ tableView: UITableView, cellForElement element: CNContact, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = element.givenName
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectElement element: CNContact, atIndexPath indexPath: IndexPath) {

    }
}

