//
//  TypeTableViewCell.swift
//  SquatsCounter
//
//  Created by Наташа on 17.10.16.
//  Copyright © 2016 nborzenko. All rights reserved.
//

import UIKit

class TypeTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layoutMargins = UIEdgeInsets.zero
        preservesSuperviewLayoutMargins = false
    }
    
}
