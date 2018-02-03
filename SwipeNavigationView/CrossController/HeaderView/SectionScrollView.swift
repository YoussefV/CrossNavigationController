//
//  SectionScrollView.swift
//  CollectionViewTest
//
//  Created by Youssef Victor on 12/29/17.
//  Copyright © 2017 Youssef Victor. All rights reserved.
//

import Foundation
import UIKit

// This is a transparent view that captures touches outside of its
// subview's frame and relays it to the subview.
// This allows me to have a scrollView whose pages are not as wide
// as the screen's width, while also being touchable along the entire
// width.
class OverlayView: UIView {
    var targetView : UIView?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self.targetView
    }
}

// This view is the row that contains all the different pages (labels)
// the rows are used for the header's sections. Each ScrollView has a
// view on top of it called the overlay view that stretches across the
// size of the HeaderView and captures all the touches and relays
// them to the ScrollView.
class SectionScrollView: UIScrollView {
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
        
        NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top,
                           multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height,
                           multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width,
                           multiplier: CGFloat(pageCount), constant: 0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading,
                           multiplier: 1.0, constant: 0).isActive = true
        
        var lastLabel : HeaderLabel? = nil
        for i in 0..<pageCount {
            let label = HeaderLabel()
            label.text = CrossConContainerViewController.pages[sectionNumber][i].pageTitle
            self.contentView.addSubview(label)
            
            NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
            
            if lastLabel == nil {
                NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
            } else {
                NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: lastLabel, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
            }
            
            lastLabel = label
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentSize = self.contentView.frame.size
    }
}

