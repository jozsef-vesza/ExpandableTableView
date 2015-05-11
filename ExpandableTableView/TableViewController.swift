//
//  TableViewController.swift
//  ExpandableTableView
//
//  Created by Vesza Jozsef on 06/05/15.
//  Copyright (c) 2015 Vesza Jozsef. All rights reserved.
//

import UIKit

let cellIdentifier = "ExpandableCell"
let statusbarHeight: CGFloat = 20

class TableViewController: UITableViewController {
    
    let viewModel = TableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset.top = statusbarHeight
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ExpandableTableViewCell
        
        cell.mainTitle = viewModel.mainTitleForRow(indexPath.row)
        cell.detailTitle = viewModel.detailTitleForRow(indexPath.row)
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if let selectedIndex = tableView.indexPathForSelectedRow() where selectedIndex == indexPath {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            return nil
        }
        
        return indexPath
    }
}
