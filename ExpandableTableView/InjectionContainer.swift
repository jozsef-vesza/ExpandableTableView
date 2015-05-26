//
//  InjectionContainer.swift
//  ExpandableTableView
//
//  Created by Vesza Jozsef on 26/05/15.
//  Copyright (c) 2015 Vesza Jozsef. All rights reserved.
//

import UIKit

let mainViewControllerId = "MainViewController"
let detailViewControllerId = "DetailViewController"

class InjectionContainer: NSObject {
    
    static let sharedContainer = InjectionContainer()
    
    lazy var photoStore: PhotoStore = {
        return PhotoStore.sharedInstance
        }()
    
    lazy var mainViewModel: TableViewModel = { [unowned self] in
        return TableViewModel(photoStore: self.photoStore)
        }()
    
    lazy var detailViewModel: DetailViewModel = { [unowned self] in
        return DetailViewModel(photoStore: self.photoStore)
        }()
    
    func mainViewControllerWithParameters(parameters: [String : AnyObject]?) -> TableViewController? {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(mainViewControllerId) as? TableViewController {
            
            viewController.viewModel = self.mainViewModel
            return viewController
        }
        
        return nil
    }
    
    func detailViewControllerWithParameters(parameters: [String : AnyObject]?) -> DetailViewController? {
        if let detailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(detailViewControllerId) as? DetailViewController {
            
            detailController.viewModel = self.detailViewModel
            
            if let parameters = parameters {
                for (key, value) in parameters {
                    detailController.viewModel.setValue(value, forKey: key)
                }
            }
            
            return detailController
        }
        
        return nil
    }
}
