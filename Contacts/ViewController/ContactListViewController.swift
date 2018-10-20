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

    private let viewModel:ContactListViewModel = Injection.new()
    private lazy var dataSource = ArrayTableViewDataSource<CNContact, UITableViewCell, CNContactViewModel>() { [weak self] contact in
        let viewController = CNContactViewController(for: contact.model)
        self?.navigationController?.show(viewController, sender: self)
    }
    
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
        self.tableView.dataSource = dataSource
        self.tableView.delegate = dataSource
    }

    private func setupViewModel() {
        viewModel.contacts.observe({ (contacts) in
            self.dataSource.data = contacts.map({CNContactViewModel(identifier: "cell", model: $0)})
            self.tableView.reloadData()
        }, errorObserver: { error in
            print(error)
        })
    }


}


