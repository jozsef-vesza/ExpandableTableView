//
//  DetailViewController.swift
//  ExpandableTableView
//
//  Created by Vesza Jozsef on 26/05/15.
//  Copyright (c) 2015 Vesza Jozsef. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet fileprivate weak var authorName: UILabel!
    @IBOutlet fileprivate weak var photoImageView: UIImageView!
    
    var viewModel: DetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorName.text = viewModel.authorName
        photoImageView.image = viewModel.photoImage
    }
    
    @IBAction fileprivate func doneButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DetailViewController: ViewControllerInitializable {
    
    static func instanceWithViewModel(_ viewModel: DetailViewModel) -> DetailViewController? {
        if let instance = self.instance() as? DetailViewController {
            instance.viewModel = viewModel
            return instance
        }
        
        return nil
    }
}
