//
// Created by Tobias Brander on 2018-10-14.
// Copyright (c) 2018 Tobias Brander. All rights reserved.
//

import Foundation
import UIKit
import Library
import Contacts

class ContactGroupViewController : UIViewController {
    var group:CNGroup!
    private let viewModel:ContactGroupViewModel = Injection.new()
    private lazy var dataSource = ArrayTableViewDataSource<CNContact, UITableViewCell, CNContactViewModel>() { [weak self] person in

    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTitle()
        self.setupViewModel()
        self.setupTableView()
    }

    private func setupTitle() {
        self.title = self.group.name
    }

    open override var isEditing: Bool {
        didSet {
            if (isEditing) {
                self.editButton.title = "Done"
            } else {
                self.editButton.title = "Edit"
            }
        }
    }

    private func setupViewModel() {
        viewModel.group = self.group
        viewModel.contacts.observe({ (contacts: [CNContact]) in
            self.dataSource.data = contacts.map({CNContactViewModel(identifier: "cell", model: $0)})
        }, errorObserver: { error in

        })
    }

    @IBAction func editButtonPressed(_ sender: Any) {
        self.isEditing = true
    }
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        
    }
    
    private func setupTableView() {
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
    }
}
