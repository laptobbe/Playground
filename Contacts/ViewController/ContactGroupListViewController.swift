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
    
    private lazy var dataSource = ArrayTableViewDataSource<CNGroup, UITableViewCell, CNGroupViewModel>() { [weak self] (group) in
        self?.performSegue(withIdentifier: "group", sender: group)
    }

    private let viewModel:ContactGroupListViewModel = Injection.singleton()
    
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
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
    }

    private func setupViewModel() {
        viewModel.groups.observe({ (groups: [CNGroup]) in
            self.dataSource.data = groups.map({CNGroupViewModel(identifier: "cell", model: $0)})
            self.tableView.reloadData()
        }, errorObserver: { error in

        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ContactGroupViewController, let group = sender as? CNGroup {
            destination.group = group
        }
    }

}
