//
//  ViewControllerExtensions.swift
//  ExpandableTableView
//
//  Created by József Vesza on 27/05/15.
//  Copyright (c) 2015 Vesza Jozsef. All rights reserved.
//

import UIKit

protocol ViewModelType {}

protocol ViewControllerInitializable {
    associatedtype T
    associatedtype U: ViewModelType
    static func instanceWithViewModel(_ viewModel: U) -> T?
}

extension UIViewController {
    
    class func instance() -> UIViewController? {
        return self.instanceFromStoryboardWithName()
    }
    
    class func instanceFromStoryboardWithName(_ storyboardName: String = "Main", fromBundle bundle: Bundle? = nil) -> UIViewController? {
        let storyboardId = NSStringFromClass(self)
        
        if let strippedId = storyboardId.components(separatedBy: CharacterSet.punctuationCharacters).last {
            return UIStoryboard(name: storyboardName, bundle: bundle).instantiateViewController(withIdentifier: strippedId) as? UIViewController
        }
        return nil
    }
}
