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
    
    let toDetailViewController = ToDetailViewPresentationController()
    let backToMainViewController = BackToMainViewPresentationController()
    
    var viewModel: TableViewModel!
    var buttonRect: CGRect?
    
    var expandedIndexPath: IndexPath? {
        didSet {
            switch expandedIndexPath {
            case .some(let index):
                tableView.reloadRows(at: [index], with: UITableViewRowAnimation.automatic)
            case .none:
                tableView.reloadRows(at: [oldValue!], with: UITableViewRowAnimation.automatic)
            }
        }
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset.top = statusbarHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 125
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ExpandableTableViewCell
        
        cell.mainTitle = viewModel.titleForRow(indexPath.row)
        cell.indexPath = indexPath
        cell.detailButtonActionHandler = { [unowned self] button, index in
            
            if let destination = DetailViewController.instanceWithViewModel(DetailViewModel(photoStore: self.viewModel.photoStore, selectedIndex: index.row)) {
            
                let newRect = cell.convert(button.frame, to: nil)
                self.buttonRect = newRect
                destination.transitioningDelegate = self
                
                self.present(destination, animated: true, completion: nil)
            }
            
        }
        
        switch expandedIndexPath {
        case .some(let expandedIndexPath) where expandedIndexPath == indexPath:
            cell.showsDetails = true
        default:
            cell.showsDetails = false
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch expandedIndexPath {
        case .some(_) where expandedIndexPath == indexPath:
            expandedIndexPath = nil
        case .some(let expandedIndex) where expandedIndex != indexPath:
            expandedIndexPath = nil
            self.tableView(tableView, didSelectRowAt: indexPath)
        default:
            expandedIndexPath = indexPath
        }
    }
}

extension TableViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return toDetailViewController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return backToMainViewController
    }
}

extension TableViewController: ViewControllerInitializable {
    
    static func instanceWithViewModel(_ viewModel: TableViewModel) -> TableViewController? {
        if let instance = self.instance() as? TableViewController {
            instance.viewModel = viewModel
            return instance
        }
        
        return nil
    }
}
