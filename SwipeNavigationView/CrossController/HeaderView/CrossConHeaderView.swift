//
//  CrossConHeaderView.swift
//  CollectionViewTest
//
//  Created by Youssef Victor on 12/28/17.
//  Copyright © 2017 Youssef Victor. All rights reserved.
//

import UIKit

class CrossConHeaderView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: Private Variables
    private let sectionCellId = "sectionCellId"
    
    private let highlighterView              = UIView()
    private let highlighterHeight : CGFloat  = 10.0
    private var bottomConstraint             = NSLayoutConstraint()
    
    // The delegate that controls a CrossConControllersView
    var transitionDelegate : CrossConTransitionDelegate? = nil
    
    // MARK: Scrolling Variables
    // This is not the cleanest way to do it,
    // but every vertical section has a last page variable
    // that stores where we left off on that section's horizontal
    // axis. This is so I can control the transitions and have
    // each section's pages be unique
    private var currSection = 0
    private var lastPage    = [0, 0]
    
    var headerOffset : CGPoint {
        return self.contentOffset
    }
    
    init(frame: CGRect) {
        // Initialize the view's Layout
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
        
        super.init(frame: frame, collectionViewLayout: flowLayout)
        
        // Setup Stuff
        self.delegate        = self
        self.dataSource      = self
        self.clipsToBounds   = true
        self.isPagingEnabled = true
        self.backgroundColor = UIColor.clear
        
        //Register Cell (Insted of doing this in storyboard)
        self.register(CrossConHeaderSectionCell.self, forCellWithReuseIdentifier: sectionCellId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //
    // MARK: CollectionViewDataSourceDelegate functions
    //
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Setup the larger collectionView's cell which is just a scrollable row
        let sectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.sectionCellId, for: indexPath) as! CrossConHeaderSectionCell
        sectionCell.setupSection(for: indexPath.row, with: self)

        return sectionCell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: (self.frame.height))
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CrossConContainerViewController.pages.count
    }
    
    // MARK: Vertical Scrolling Code.
    //       This punts off the scrolling logic to the HeaderViewScrollDelegate
    internal func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.scrollViewWillBeginDragging(scrollView, vertically: true)
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollViewDidScroll(scrollView, vertically: true)
    }
    
    internal func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.scrollViewWillEndDragging(scrollView, velocity, targetContentOffset, vertically: true)
    }
    
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndDecelerating(scrollView, vertically: true)
    }

}

// TODO:
/**
 
 --- OBSERVE:  Problem C1: StartOffset is reset incorrectly when the transition restarts
 Problem S1: Sometimes gets stuck on a vc, even though print movement is correct, the vc's are not moving

 
 
 --- ANALYZE:   Problem C1: I'm calling scrollViewWillBeginDragging after the transition cancels too late.
 
 
 --- FIX: TEMPFIX C1: Determine starting offset by rounding to nearest VC.
          LONGFIX C1: Make your own UITransitioning stuff
 
 
 
 **/


// MARK: Interactive Transitioning Code
extension CrossConHeaderView : CrossConHeaderViewScrollDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView, vertically: Bool) {
        // MARK: Interactive Transitioning Code
        let positive = vertically ? scrollView.panGestureRecognizer.velocity(in: self).y > 0 :
                                    scrollView.panGestureRecognizer.velocity(in: self).x > 0
        transitionDelegate?.startTransition(vertically: true, positive: positive)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView, vertically: Bool) {
        let offset = vertically ? scrollView.contentOffset.y : scrollView.contentOffset.x
        let total  = vertically ? scrollView.frame.height    : scrollView.frame.width
        
        transitionDelegate?.updateTransition(with: offset/total, vertically: vertically)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>, vertically: Bool) {
        let offset = vertically ? targetContentOffset.pointee.y : targetContentOffset.pointee.x
        let total  = vertically ? scrollView.frame.height       : scrollView.frame.width
        let newIndex = Int(offset/total)
        
        if (vertically && currSection != newIndex) {
            self.currSection = Int(offset/total)
            print("Moving to section: \(currSection), page: \(self.lastPage[currSection])")
        } else if (self.lastPage[currSection] != newIndex){
            self.lastPage[currSection] = Int(offset/total)
            print("Moving to section: \(currSection), page: \(self.lastPage[currSection])")
        }
        
        transitionDelegate?.completeTransition(to: IndexPath(item: self.lastPage[currSection],
                                                             section: currSection))
    }
    
    // Transition Fixed
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView, vertically: Bool) {
    }
    
    
    // HANDLE TRANSITION
    internal func transitionVertically(fromSection: Int, toSection: Int) {
        print("""
            Transitioning Vertically
            from Sect\(fromSection)-Page\(lastPage[fromSection])
            to   Sect\(toSection)-Page\(lastPage[toSection])\n
            """)
    }
    
    internal func transitionHorizontally(fromPage: Int, toPage: Int) {
        print("""
            Transitioning Horizontally
            from Sect\(currSection)-Page\(fromPage)
            to   Sect\(currSection)-Page\(toPage)\n
            """)
    }
}
