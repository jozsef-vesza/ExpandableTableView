//
//  TableViewModel.swift
//  ExpandableTableView
//
//  Created by Vesza Jozsef on 06/05/15.
//  Copyright (c) 2015 Vesza Jozsef. All rights reserved.
//

import UIKit

struct TableViewModel {
    
    private let mainModel = [
        "Item 0",
        "Item 1",
        "Item 2",
    ]
    
    private let detailModel = [
        "Detail 0",
        "Detail 1",
        "Detail 2",
    ]
    
    var count: Int {
        return mainModel.count
    }
    
    func mainTitleForRow(row: Int) -> String {
        return mainModel[row]
    }
    
    func detailTitleForRow(row: Int) -> String {
        return detailModel[row]
    }
}