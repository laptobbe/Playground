//
//  TableViewCellViewModel.swift
//  Library
//
//  Created by Tobias Brander on 2018-10-20.
//  Copyright © 2018 Tobias Brander. All rights reserved.
//

import Foundation

open class TableViewCellViewModel<Model, Cell:UITableViewCell> : ViewModel {
    var identifier:String = ""
    public var model:Model! = nil
    public required init() {
        
    }
    
    public convenience init(identifier:String, model:Model) {
        self.init()
        self.identifier = identifier
        self.model = model
    }
    
    public func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:IndexPath) -> Cell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Cell
        self.configure(cell:cell, withModel:self.model)
        return cell
    }
    
    open func configure(cell:Cell, withModel model:Model) {
        
    }
}
