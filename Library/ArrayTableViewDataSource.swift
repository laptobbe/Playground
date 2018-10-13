//
//  ArrayTableViewDataSource.swift
//  Library
//
//  Created by Tobias Brander on 2018-10-11.
//  Copyright © 2018 Tobias Brander. All rights reserved.
//

import Foundation
import UIKit

open class ArrayTableViewDataSource<Element>: NSObject, UITableViewDataSource, UITableViewDelegate {
    public typealias ArrayTableViewDataSourceDelegate = (Element)->()
    let delegate:ArrayTableViewDataSourceDelegate?
    
    public init(data:[Element] = [], delegate:ArrayTableViewDataSourceDelegate? = nil) {
        self.data = data
        self.delegate = delegate
        super.init()
    }
    
    public var data:[Element]
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.tableView(tableView, cellForElement: data[indexPath.row], atIndexPath: indexPath)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView(tableView, didSelectElement:data[indexPath.row], atIndexPath:indexPath)
    }

    open func tableView(_ tableView:UITableView, didSelectElement element:Element, atIndexPath indexPath:IndexPath) {
        self.delegate?(element)
    }

    open func tableView(_ tableView:UITableView, cellForElement element:Element, atIndexPath indexPath:IndexPath) -> UITableViewCell {
        fatalError("Needs to be overwritten")
    }
}

