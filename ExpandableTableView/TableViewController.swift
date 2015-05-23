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
    
    var expandedIndexPath: NSIndexPath? {
        didSet {
            switch expandedIndexPath {
            case .Some(let index):
                tableView.reloadRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Automatic)
            case .None:
                tableView.reloadRowsAtIndexPaths([oldValue!], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset.top = statusbarHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 125
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ExpandableTableViewCell
        
        cell.mainTitle = viewModel.mainTitleForRow(indexPath.row)
        cell.detailTitle = viewModel.detailTitleForRow(indexPath.row)
        
        switch expandedIndexPath {
        case .Some(let expandedIndexPath) where expandedIndexPath == indexPath:
            cell.showsDetails = true
        default:
            cell.showsDetails = false
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        switch expandedIndexPath {
        case .Some(_) where expandedIndexPath == indexPath:
            expandedIndexPath = nil
        case .Some(let expandedIndex) where expandedIndex != indexPath:
            expandedIndexPath = nil
            self.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        default:
            expandedIndexPath = indexPath
        }
    }
}
