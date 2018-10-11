//
//  ArrayTableViewDataSource.swift
//  Library
//
//  Created by Tobias Brander on 2018-10-11.
//  Copyright © 2018 Tobias Brander. All rights reserved.
//

import Foundation
import UIKit

open class ArrayTableViewDataSource<Element>: NSObject, UITableViewDataSource {
    public init(data:[Element] = []) {
        self.data = data
        super.init()
    }
    
    public var data:[Element]
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.tableView(tableView, cellForElement: data[indexPath.row], atIndexPath: indexPath)
    }
    
    open func tableView(_ tableView:UITableView, cellForElement element:Element, atIndexPath indexPath:IndexPath) -> UITableViewCell {
        fatalError("Needs to be overwritten")
    }
}

