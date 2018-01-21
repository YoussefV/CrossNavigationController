//
//  Cell.swift
//  CollectionViewTest
//
//  Created by Youssef Victor on 8/8/17.
//  Copyright © 2017 Youssef Victor. All rights reserved.
//

import UIKit

//This is your main view controllers cell object
class SectionCell: UICollectionViewCell {
    
    // MARK: Constants
    let pageCellId = "pageCellId"
    
    // MARK: Private Internal Variables
    fileprivate let overlayView = OverlayView()
    fileprivate let scrollView  = SectionScrollView()
    fileprivate var delegate    : HeaderViewScrollDelegate?
    
    // MARK: Initializer function
    func setupSection(for rowNumber: Int, with delegate : HeaderViewScrollDelegate) {
        // Set Delegates
        self.delegate = delegate
        self.scrollView.delegate = self
        
        // Layout Subviews
        self.addSubview(self.scrollView)
        self.addSubview(self.overlayView)
        
        self.addLayoutConstraints()
        self.scrollView.setupPages(for: rowNumber)
    }
    
    private func addLayoutConstraints() {
        // Remove Bad Layout Stuff
        self.overlayView.targetView = self.scrollView
        self.overlayView.isUserInteractionEnabled                  = false
        self.overlayView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.showsHorizontalScrollIndicator             = false
        self.scrollView.translatesAutoresizingMaskIntoConstraints  = false
        
        // overlayView stretches everything
        NSLayoutConstraint(item: self.overlayView, attribute:  .bottom, relatedBy: .equal, toItem: self, attribute: .bottom,
                           multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self.overlayView, attribute:     .top, relatedBy: .equal, toItem: self, attribute: .top,
                           multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self.overlayView, attribute: .leadingMargin, relatedBy: .equal, toItem: self, attribute: .leadingMargin,
                           multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self.overlayView, attribute: .trailingMargin, relatedBy: .equal, toItem: self, attribute: .trailingMargin,
                           multiplier: 1.0, constant: 0.0).isActive = true
        
        // interiorCollectionView is half the overlay width and centered
        NSLayoutConstraint(item: self.scrollView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom,
                           multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self.scrollView, attribute:    .top, relatedBy: .equal, toItem: self, attribute: .top,
                           multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self.scrollView, attribute:  .width, relatedBy: .equal, toItem: self.overlayView, attribute: .width, multiplier: 0.5, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self.scrollView, attribute: .centerX, relatedBy: .equal, toItem: self.overlayView, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
    }
}

// MARK: ScrollViewDelegate Punting to HeaderView
extension SectionCell : UIScrollViewDelegate {
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(scrollView, vertically: false)
    }
    
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndDecelerating(scrollView, vertically: false)
    }
    
}
