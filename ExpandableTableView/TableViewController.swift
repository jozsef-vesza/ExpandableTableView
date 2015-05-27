//
//  TableViewController.swift
//  ExpandableTableView
//
//  Created by Vesza Jozsef on 06/05/15.
//  Copyright (c) 2015 Vesza Jozsef. All rights reserved.
//

import UIKit

let cellIdentifier = "ExpandableCell"
let detailSegueIdentifier = "showDetailSegue"
let statusbarHeight: CGFloat = 20

class TableViewController: UITableViewController {
    
    // MARK: - Properties and setup
    
    let toDetailViewController = ToDetailViewPresentationController()
    let backToMainViewController = BackToMainViewPresentationController()
    
    var viewModel: TableViewModel!
    var buttonRect: CGRect?
    
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
    
    class func tableViewControllerWithViewModel(viewModel: TableViewModel) -> TableViewController? {
        if let instance = self.instance() as? TableViewController {
            instance.viewModel = viewModel
            return instance
        }
        
        return nil
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset.top = statusbarHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 125
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ExpandableTableViewCell
        
        cell.mainTitle = viewModel.titleForRow(indexPath.row)
        cell.indexPath = indexPath
        cell.detailButtonActionHandler = { [unowned self] button, index in
            
            if let destination = DetailViewController.detailViewControllerWithViewModel(DetailViewModel(photoStore: self.viewModel.photoStore, selectedIndex: index.row)) {
            
                let newRect = cell.convertRect(button.frame, toView: nil)
                self.buttonRect = newRect
                destination.transitioningDelegate = self
                
                self.presentViewController(destination, animated: true, completion: nil)
            }
            
        }
        
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

extension TableViewController: UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return toDetailViewController
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return backToMainViewController
    }
}