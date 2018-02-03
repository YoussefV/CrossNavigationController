//
//  CrossConControllersSectionCell.swift
//  SwipeNavigationView
//
//  Created by Youssef Victor on 1/31/18.
//  Copyright © 2018 Youssef Victor. All rights reserved.
//

import UIKit

class CrossConControllersSectionCell: UICollectionViewCell {
    
    // MARK: Constants
    let controllerCellId = "controllerCellId"
    
    let scrollView  = ControllerScrollView(frame: .zero)
    

    // MARK: Initializer function
    func setupSection(for sectionNumber: Int) {
        
        // Layout Subviews
        self.addSubview(self.scrollView)
        
        // Add layout constraints
        self.addLayoutConstraints()
        self.scrollView.setupPages(for: sectionNumber)
    }
    
    private func addLayoutConstraints() {
        // Remove Bad Layout Stuff
        self.scrollView.showsHorizontalScrollIndicator             = false
        self.scrollView.translatesAutoresizingMaskIntoConstraints  = false
        
        // overlayView stretches everything
        NSLayoutConstraint.activate([
        self.scrollView.heightAnchor.constraint(equalTo: self.heightAnchor),
        self.scrollView.topAnchor.constraint(equalTo: self.topAnchor),
        self.scrollView.leftAnchor.constraint(equalTo: self.leftAnchor),
        self.scrollView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }
}
