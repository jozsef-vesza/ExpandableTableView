//
//  ExpandableTableViewCell.swift
//  ExpandableTableView
//
//  Created by Vesza Jozsef on 06/05/15.
//  Copyright (c) 2015 Vesza Jozsef. All rights reserved.
//

import UIKit

let detailViewDefaultHeight: CGFloat = 44

class ExpandableTableViewCell: UITableViewCell {

    @IBOutlet private weak var mainTitleLabel: UILabel!
    @IBOutlet private weak var detailTitleLabel: UILabel!
    @IBOutlet private weak var detailViewHeightConstraint: NSLayoutConstraint!
    
    var mainTitle: String! {
        didSet {
            mainTitleLabel.text = mainTitle
        }
    }
    
    var detailTitle: String! {
        didSet {
            detailTitleLabel.text = detailTitle
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        detailViewHeightConstraint.constant = selected ? detailViewDefaultHeight : 0
        UIView.animateWithDuration(0.3) {
            self.layoutIfNeeded()
        }
    }
}
