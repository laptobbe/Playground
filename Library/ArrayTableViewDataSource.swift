//
//  ArrayTableViewDataSource.swift
//  Library
//
//  Created by Tobias Brander on 2018-10-11.
//  Copyright © 2018 Tobias Brander. All rights reserved.
//

import Foundation
import UIKit
 
open class ArrayTableViewDataSource<Model, Cell:UITableViewCell, CellViewModel:TableViewCellViewModel<Model, Cell>>: NSObject, UITableViewDataSource, UITableViewDelegate {
    public typealias ArrayTableViewDataSourceDelegate = (CellViewModel)->()
    let delegate:ArrayTableViewDataSourceDelegate?
    
    public init(data:[CellViewModel] = [], delegate:ArrayTableViewDataSourceDelegate? = nil) {
        self.data = data
        self.delegate = delegate
        super.init()
    }
    
    public var data:[CellViewModel]
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.tableView(tableView, cellForElement: data[indexPath.row], atIndexPath: indexPath)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView(tableView, didSelectElement:data[indexPath.row], atIndexPath:indexPath)
    }

    public func tableView(_ tableView:UITableView, didSelectElement element:CellViewModel, atIndexPath indexPath:IndexPath) {
        self.delegate?(element)
    }

    public func tableView(_ tableView:UITableView, cellForElement element:CellViewModel, atIndexPath indexPath:IndexPath) -> Cell {
        return element.tableView(tableView: tableView, cellForRowAtIndexPath: indexPath)
    }
}

