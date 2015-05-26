//
//  DetailViewModel.swift
//  ExpandableTableView
//
//  Created by Vesza Jozsef on 26/05/15.
//  Copyright (c) 2015 Vesza Jozsef. All rights reserved.
//

import UIKit

class DetailViewModel: NSObject {
    
    let photoStore: PhotoStore
    dynamic var selectedIndex = 0
    
    init(photoStore: PhotoStore) {
        self.photoStore = photoStore
        super.init()
    }
    
    var authorName: String {
        return photoStore.photos[selectedIndex].author
    }
    
    var photoImage: UIImage? {
        return photoStore.photos[selectedIndex].image
    }
}