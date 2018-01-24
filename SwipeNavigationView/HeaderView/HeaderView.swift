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
    
    
    
    // Pages
    static let pages = [[PageController(title: "Sect0-Page0", color: .red), PageController(title: "Sect0-Page1", color: .green), PageController(title: "Sect0-Page2", color: .blue)],
                        [PageController(title: "Sect1-Page0", color: .cyan), PageController(title: "Sect1-Page1", color: .yellow)]]
                        
    
    // MARK: Delegate fields
    fileprivate var animator: UIViewControllerAnimatedTransitioning!
    
    // MARK: Interactive Transitioning Code
    fileprivate var interactionController = HeaderViewInteractionController()
    
    
    var fromSection: Int = 0
    var fromRow: Int = 0
    
    var toSection: Int = 0
    var toRow: Int = 0
    
    weak var container: InteractiveContainerViewController?
    
    // MARK: InteractiveTransitioning Fields
//    private let progressNeeded: CGFloat = 0.35
//
//    private let velocityNeeded: CGFloat = 550
//
//    private var lastVelocity = CGPoint.zero
//
//    private var leftToRightTransition = false
//    private var shouldCompleteTransition = false
//
//    // This block gets run when the gesture recognizer start recognizing a pan. Inside, the start of a transition can be triggered.
//    private let gestureRecognizedBlock: ((_ recognizer: UIPanGestureRecognizer) -> Void)
    
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
        
        self.animator = SwipeToSlideTransitionAnimation()
        
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


// MARK: Interactive Transitioning Code
extension HeaderView : HeaderViewScrollDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView, vertically: Bool) {
        // MARK: Interactive Transitioning Code
        let startingOffset = vertically ? scrollView.contentOffset.y : scrollView.contentOffset.x
        let scrollVelocity = vertically ? scrollView.panGestureRecognizer.velocity(in: self).y :
            scrollView.panGestureRecognizer.velocity(in: self).x
        
        // Initialize transition values needed for the interactionController
        interactionController.setTransitionValues(startOffset: startingOffset,
                                                  velocity: scrollVelocity,
                                                  width: scrollView.bounds.width,
                                                  vertically: vertically)
        {
            if (vertically) {
                // Get the next vertical viewcontroller to transition to
                self.toSection = scrollVelocity >= 0 ? self.currSection + 1 : self.currSection - 1
                self.toSection = min(max(self.toSection, 0), HeaderView.pages.count - 1)
                
                self.fromSection = self.currSection
                self.fromRow = self.lastPage[self.fromSection]
                self.toRow = self.lastPage[self.toSection]
                
                if (self.toSection != self.fromSection) {
                    // Initiate that transition if it's a different viewcontroller and not at the
                    // edges
                    self.container?.transition(to: HeaderView.pages[self.toSection][self.toRow],
                                               interactive: true)
                }
            } else {
                // Get the next horizontal viewcontroller to transition to
                self.toRow = scrollVelocity >= 0 ? self.lastPage[self.fromSection] + 1 :
                                                   self.lastPage[self.fromSection] - 1
                self.toRow = min(max(self.toRow, 0), HeaderView.pages[self.fromSection].count - 1)
                
                self.fromSection = self.currSection
                self.toSection   = self.currSection
                self.fromRow     = self.lastPage[self.fromSection]
                
                if (self.toRow != self.fromRow) {
                    // Initiate that transition if it's a different viewcontroller and not at the
                    // edges
                    self.container?.transition(to: HeaderView.pages[self.toSection][self.toRow],
                                               interactive: true)
                }
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView, vertically: Bool) {
        // MARK: Interactive Transitioning Code
        let offset = vertically ? scrollView.contentOffset.y : scrollView.contentOffset.x
        let scrollVelocity = vertically ? scrollView.panGestureRecognizer.velocity(in: self).y :
            scrollView.panGestureRecognizer.velocity(in: self).x
        interactionController.headerDidScroll(offset: offset, width: scrollView.bounds.width, velocity: scrollVelocity)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>, vertically: Bool) {
        // MARK: Interactive Transitioning Code
        interactionController.headerEndedScroll()
    }
    
    // Transition Fixed
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView, vertically: Bool) {
        // Calculate new page based on new offset
        let newPage = Int((scrollView.contentOffset.x * CGFloat(HeaderView.pages[currSection].count)) / scrollView.contentSize.width)
        
        // Calculate new row based on new offset
        let newSection = Int(scrollView.contentOffset.y * CGFloat(HeaderView.pages.count) /                         scrollView.contentSize.height)
        
        
        if (vertically) {
            // this does animated non-interactive transition
            fromSection = currSection
            toSection = newSection
            fromRow = lastPage[fromSection]
            toRow = lastPage[toSection]
            container?.transition(to: HeaderView.pages[toSection][toRow], animated: true, interactive: false)
            
            // Do ViewController transition stuff (vertically)
            self.transitionVertically(fromSection: currSection, toSection: newSection)
            self.currSection = newSection
        } else {
            fromSection = currSection
            toSection = currSection
            fromRow = lastPage[fromSection]
            toRow = newPage
            container?.transition(to: HeaderView.pages[toSection][toRow], animated: true, interactive: false)
            
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


extension HeaderView: InteractiveTransitioningContainerDelegate {
    
    // MARK: InteractiveTransitioningContainerDelegate
    
    public func initialViewController(_ interactiveTransitioningContainer: InteractiveTransitioningContainer) -> UIViewController {
        return HeaderView.pages[0][0]
    }
    
    public func interactiveTransitioningContainer(
        _ interactiveTransitioningContainer: InteractiveTransitioningContainer,
        animationControllerForTransitionFrom fromViewController: UIViewController,
        to toViewController: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return animator
    }
    
    public func interactiveTransitioningContainer(
        _ interactiveTransitioningContainer: InteractiveTransitioningContainer,
        animationPositionsForTransitionFrom fromViewController: UIViewController,
        to toViewController: UIViewController) -> InteractiveTransitioningContainerAnimationPositions {
        
        // normally we would use fromViewController and toViewController to determine section and row, here I keep it in properties
        
        let vertical = fromSection != toSection
        
        if vertical {
            
            let goingDown = fromSection < toSection
            
            let travelDistance = goingDown ? -interactiveTransitioningContainer.containerView.bounds.size.height : interactiveTransitioningContainer.containerView.bounds.size.height
            
            let fromInitialFrame = interactiveTransitioningContainer.containerView.bounds
            let toFinalFrame = interactiveTransitioningContainer.containerView.bounds
            let fromFinalFrame = interactiveTransitioningContainer.containerView.bounds.offsetBy(dx: 0, dy: travelDistance)
            let toInitialFrame = interactiveTransitioningContainer.containerView.bounds.offsetBy(dx: 0, dy: -travelDistance)
            
            return InteractiveTransitioningContainerAnimationPositionsImpl(fromInitialFrame: fromInitialFrame, fromFinalFrame: fromFinalFrame, toInitialFrame: toInitialFrame, toFinalFrame: toFinalFrame)
            
        } else {
            
            let goingRight = fromRow < toRow
            
            let travelDistance = goingRight ? -interactiveTransitioningContainer.containerView.bounds.size.width : interactiveTransitioningContainer.containerView.bounds.size.width
            
            let fromInitialFrame = interactiveTransitioningContainer.containerView.bounds
            let toFinalFrame = interactiveTransitioningContainer.containerView.bounds
            let fromFinalFrame = interactiveTransitioningContainer.containerView.bounds.offsetBy(dx: travelDistance, dy: 0)
            let toInitialFrame = interactiveTransitioningContainer.containerView.bounds.offsetBy(dx: -travelDistance, dy: 0)
            
            return InteractiveTransitioningContainerAnimationPositionsImpl(fromInitialFrame: fromInitialFrame, fromFinalFrame: fromFinalFrame, toInitialFrame: toInitialFrame, toFinalFrame: toFinalFrame)
        }
    }
    
    public func interactiveTransitioningContainer(
        _ interactiveTransitioningContainer: InteractiveTransitioningContainer,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        // TODO: this HeaderView would become interaction controller
        // for interactive transitions you need to implement interaction controller
        // see for inspiration https://github.com/MilanNosal/InteractiveTransitioningContainer/blob/master/InteractiveTransitioningContainer/SwipeToSlidePanGestureInteractiveTransition.swift
        // the problem here is that I use pan gesture, but you want the transitions be controller by
        // scrolling of the collectionView - you have to watch scrolling and use
        // controller.updateInteractiveTransition(percentComplete: progress)
        // and controller.finishInteractiveTransition() / controller.immediateFinishInteractiveTransition()
        // and controller.cancelInteractiveTransition() / controller.cancelFinishInteractiveTransition()
        // to react to scrolling
        
        // P.S.: you start a new transition (after finishing/cancelling the previous one) by calling transition(to: newPage, interactive: true) called on the interactiveContainer, and then you control it by using aforementioned methods
        
        // MARK: Interactive Transitioning Code
        return self.interactionController
    }
    
    public func interactiveTransitioningContainer(
        _ interactiveTransitioningContainer: InteractiveTransitioningContainer,
        willTransitionFrom fromViewController: UIViewController,
        to toViewController: UIViewController,
        coordinatedBy transitionCoordinator: UIViewControllerTransitionCoordinator) {
        
    }
    
    public func interactiveTransitioningContainer(
        _ interactiveTransitioningContainer: InteractiveTransitioningContainer,
        transitionFinishedTo viewController: UIViewController,
        wasCancelled: Bool) {
        
    }
    
    public func interactiveTransitioningContainer(
        _ interactiveTransitioningContainer: InteractiveTransitioningContainer,
        layoutIfNotAlready viewController: UIViewController, inContainerView containerView: UIView) {
        viewController.view.frame = containerView.bounds
    }
    
    public func interactiveTransitioningContainer(
        _ interactiveTransitioningContainer: InteractiveTransitioningContainer,
        releaseLayoutOf viewController: UIViewController, inContainerView containerView: UIView) {
        
    }
    
}
