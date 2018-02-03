//
//  ControllerScrollView.swift
//  CollectionViewTest
//
//  Created by Youssef Victor on 12/29/17.
//  Copyright © 2017 Youssef Victor. All rights reserved.
//

import Foundation
import UIKit

// This view is the row that contains all the different viewControllers
// the rows are used for the ViewController rows.
// This view should be controlled with the transitioner.
// TODO: Wire up the transitioner
class ControllerScrollView: UIScrollView {
    // The scrollview's contentview that is going to be fixed
    // while we move around it using the ScrollView movement.
    // This is basically the entire horizontal section
    let contentView = UIView()
    
    func setupPages(for sectionNumber: Int){
        // Autolayout stuff
        self.translatesAutoresizingMaskIntoConstraints             = false
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.clipsToBounds                             = false
        self.clipsToBounds = false
        self.isPagingEnabled = true
        self.addSubview(contentView)
        
        let pageCount = CrossConContainerViewController.pages[sectionNumber].count
        
        // Setup the contentView's constraints
        NSLayoutConstraint.activate([
            self.contentView.heightAnchor.constraint(equalTo: self.heightAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor),
            self.contentView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.widthAnchor,
                                                    multiplier: CGFloat(pageCount)),
            ])
        
        // Go through each of the viewControllers and lay them out side-by-side
        // the last controller is used to set the left anchor
        var lastController : UIView?
        for i in 0..<pageCount {
            let newPage = CrossConContainerViewController.pages[sectionNumber][i]
            let view = newPage.view!
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
            
            NSLayoutConstraint.activate([
                view.heightAnchor.constraint(equalTo: self.heightAnchor),
                view.topAnchor.constraint(equalTo: self.topAnchor),
                view.widthAnchor.constraint(equalTo: self.widthAnchor),
                view.leftAnchor.constraint(equalTo: (lastController == nil) ? self.leftAnchor : lastController!.rightAnchor)
            ])
            
            lastController = view
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // TODO: Figure out what this is for
        self.contentSize = self.contentView.frame.size
    }
}

