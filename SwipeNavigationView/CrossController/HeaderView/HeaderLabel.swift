//
//  HeaderLabel.swift
//  CollectionViewTest
//
//  Created by Youssef Victor on 12/29/17.
//  Copyright © 2017 Youssef Victor. All rights reserved.
//

import UIKit

//
// Used for CrossConHeaderSectionCell.
// Just a custom
//

class HeaderLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont(name: "Arial", size: 30.0)
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.7
        self.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
