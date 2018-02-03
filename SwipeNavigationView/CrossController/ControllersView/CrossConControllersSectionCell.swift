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
    let controllerCellId = "controllersSectionCellId"
    
    let controllersCollection  = ControllersCollectionView(frame: .zero)
    

    // MARK: Initializer function
    func setupSection(for sectionNumber: Int) {
        
        // Layout Subviews
        self.addSubview(self.controllersCollection)
        
        // Add layout constraints
        self.addLayoutConstraints()
        self.controllersCollection.setSectionNumber(sectionNumber)
    }
    
    private func addLayoutConstraints() {
        // Remove Bad Layout Stuff
        self.controllersCollection.showsHorizontalScrollIndicator             = false
        self.controllersCollection.translatesAutoresizingMaskIntoConstraints  = false
        
        // overlayView stretches everything
        NSLayoutConstraint.activate([
        self.controllersCollection.heightAnchor.constraint(equalTo: self.heightAnchor),
        self.controllersCollection.topAnchor.constraint(equalTo: self.topAnchor),
        self.controllersCollection.leftAnchor.constraint(equalTo: self.leftAnchor),
        self.controllersCollection.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }
}
