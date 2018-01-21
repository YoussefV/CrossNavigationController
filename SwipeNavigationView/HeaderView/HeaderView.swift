//
//  HeaderView.swift
//  CollectionViewTest
//
//  Created by Youssef Victor on 12/28/17.
//  Copyright © 2017 Youssef Victor. All rights reserved.
//

import UIKit

class HeaderView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: Private Variables
    private let sectionCellId = "sectionCellId"
    
    private let highlighterView              = UIView()
    private let highlighterHeight : CGFloat  = 10.0
    private var bottomConstraint             = NSLayoutConstraint()
    
    // Page Labels
    static let pages = [["Sect0-Page0", "Sect0-Page1", "Sect0-Page2", "Sect2Page3"],
                        ["Sect1-Page0", "Sect1-Page1", "Sect1-Page2"],
                        ["Sect2-Page0", "Sect2-Page1", "Sect2-Page2", "Sect2-Page3"]]
    
    // MARK: Scrolling Variables
    // This is not the cleanest way to do it,
    // but every vertical section has a last page variable
    // that stores where we left off on that section's horizontal
    // axis. This is so I can control the transitions and have
    // each section's pages be unique
    private var currSection = 0
    private var lastPage    = [0, 0, 0]
    
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
        self.register(SectionCell.self, forCellWithReuseIdentifier: sectionCellId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Setup the larger collectionView's cell which is just a scrollable row
        let sectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.sectionCellId, for: indexPath) as! SectionCell
        sectionCell.setupSection(for: indexPath.row, with: self)

        return sectionCell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: (self.frame.height))
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HeaderView.pages.count
    }
    
    // MARK: Vertical Scrolling Code.
    //       This punts off the scrolling logic to the HeaderViewScrollDelegate
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollViewDidScroll(scrollView, vertically: true)
    }
    
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndDecelerating(scrollView, vertically: true)
    }

}


// FIXME: Needs to have interactive transitions
extension HeaderView : HeaderViewScrollDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView, vertically: Bool) {
       // TODO: Interactive Transition
    }
    
    // Transition Fixed
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView, vertically: Bool) {
        // Calculate new page based on new offset
        let newPage = Int((scrollView.contentOffset.x * CGFloat(HeaderView.pages[currSection].count)) / scrollView.contentSize.width)
        
        // Calculate new row based on new offset
        let newSection = Int(scrollView.contentOffset.y * CGFloat(HeaderView.pages.count) /                         scrollView.contentSize.height)
        
        
        if (vertically) {
            // Do ViewController transition stuff (vertically)
            self.transitionVertically(fromSection: currSection, toSection: newSection)
            self.currSection = newSection
        } else {
             // Do ViewController transition stuff (horizontally)
            self.transitionHorizontally(fromPage: lastPage[currSection], toPage: newPage)
            self.lastPage[currSection] = newPage
        }
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
