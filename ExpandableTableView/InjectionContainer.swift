//
//  InjectionContainer.swift
//  ExpandableTableView
//
//  Created by Vesza Jozsef on 26/05/15.
//  Copyright (c) 2015 Vesza Jozsef. All rights reserved.
//

import UIKit

let storyboardId = "Main"
let mainViewControllerId = "MainViewController"
let detailViewControllerId = "DetailViewController"

class InjectionContainer: NSObject {
    
    static let sharedContainer = InjectionContainer()
    
    dynamic lazy var photoStore: PhotoStore = {
        return PhotoStore.sharedInstance
        }()
    
    dynamic lazy var mainViewModel: TableViewModel = { [unowned self] in
        return TableViewModel(photoStore: self.photoStore)
        }()
    
    dynamic lazy var detailViewModel: DetailViewModel = { [unowned self] in
        return DetailViewModel(photoStore: self.photoStore)
        }()
    
    dynamic var mainViewController: TableViewController? {
    
        if let viewController = UIStoryboard(name: storyboardId, bundle: nil).instantiateViewControllerWithIdentifier(mainViewControllerId) as? TableViewController {
        
            viewController.viewModel = self.resolveByKey("mainViewModel", withParameters: nil) as! TableViewModel
            
            return viewController
        }
        
        return nil
    }
    
    dynamic var detailViewController: DetailViewController? {
    
        if let viewController = UIStoryboard(name: storyboardId, bundle: nil).instantiateViewControllerWithIdentifier(detailViewControllerId) as? DetailViewController {
            
            viewController.viewModel = self.resolveByKey("detailViewModel", withParameters: nil) as! DetailViewModel
            
            return viewController
        }
        
        return nil
    }
    
    func resolveByKey(key: String, withParameters parameters: [String: AnyObject]?) -> AnyObject? {
        
        if let resolved: AnyObject = self.valueForKey(key) {
            
            if let parameters = parameters {
                
                map(parameters) { (key, value) in
                    resolved.setValue(value, forKey: key)
                }
            }
            
            return resolved
        }
        
        return nil
    }
}