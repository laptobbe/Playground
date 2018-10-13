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
import ContactsUI

class ContactListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    let viewModel:ContactListViewModel = Injection.new()
    private var dataSource:ContactsListTableViewSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.deselectCurrent()
    }

    private func deselectCurrent() {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    private func setupTableView() {
        self.dataSource = ContactsListTableViewSource() { [weak self] contact in
            let viewController = CNContactViewController(for: contact)
            self?.navigationController?.show(viewController, sender: self)
        }
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

    private class ContactsListTableViewSource : ArrayTableViewDataSource<CNContact> {

        override func tableView(_ tableView: UITableView, cellForElement element: CNContact, atIndexPath indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = element.givenName
            return cell
        }
    }
}


