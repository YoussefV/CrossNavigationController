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
    static let pages = [[PageController(title: "Sect0-Page0", color: .green), PageController(title: "Sect0-Page1", color: .red), PageController(title: "Sect0-Page2", color: .orange)],
                        [PageController(title: "Sect1-Page0", color: .cyan), PageController(title: "Sect0-Page1", color: .yellow)]]
                        
    
    // MARK: Delegate fields
    fileprivate lazy var animator: UIViewControllerAnimatedTransitioning! = SwipeToSlideTransitionAnimation()
    
    // MARK: Interactive Transitioning Code
    fileprivate lazy var interactionController = HeaderViewInteractionController()
    
    var fromSection: Int = 0
    var fromRow: Int = 0
    
    var toSection: Int = 0
    var toRow: Int = 0
    
    weak var container: InteractiveContainerViewController?
    
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

// TODO:
/**
 
 --- OBSERVE:  Problem C1: StartOffset is reset incorrectly when the transition restarts
 Problem S1: Sometimes gets stuck on a vc, even though print movement is correct, the vc's are not moving

 
 
 --- ANALYZE:   Problem C1: I'm calling scrollViewWillBeginDragging after the transition cancels too late.
 
 
 --- FIX: TEMPFIX C1: Determine starting offset by rounding to nearest VC.
          LONGFIX C1: Make your own UITransitioning stuff
 
 
 
 **/


// MARK: Interactive Transitioning Code
extension HeaderView : HeaderViewScrollDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView, vertically: Bool) {
        // MARK: Interactive Transitioning Code
        let startingOffset = vertically ? CGFloat(self.fromSection) * scrollView.frame.height  :
                                        CGFloat(self.lastPage[self.fromSection]) * scrollView.frame.width
//        let startingOffset = vertically ? scrollView.contentOffset.y : scrollView.contentOffset.x
        
        let scrollVelocity = vertically ? scrollView.panGestureRecognizer.velocity(in: self).y :
            scrollView.panGestureRecognizer.velocity(in: self).x
            
        let recognizedBlock = {
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
                let currentRow = Int(scrollView.contentOffset.x / scrollView.frame.width)
                self.toRow = scrollVelocity < 0 ?  currentRow + 1 :
                                                   currentRow - 1
                self.toRow = min(max(self.toRow, 0), HeaderView.pages[self.fromSection].count - 1)
                
                self.fromSection = self.currSection
                self.toSection   = self.currSection
                self.fromRow     = currentRow
                
                print("Starting transition: fromRow: \(self.fromRow), toRow: \(self.toRow)\n")
                
                // Initiate that transition if it's a different viewcontroller and not at the
                // edges
                if (self.fromRow != self.toRow) {
                    self.container?.transition(to: HeaderView.pages[self.toSection][self.toRow],
                                               interactive: true)
                }
            }
        }

        // Initialize transition values needed for the interactionController
        interactionController.setTransitionValues(startOffset: startingOffset,
                                                  velocity: scrollVelocity,
                                                  width: scrollView.bounds.width,
                                                  vertically: vertically,
                                                  recognizedBlock: recognizedBlock)
        
        // Running the recognized block
        recognizedBlock()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView, vertically: Bool) {
        // Ignore if the user isn't touching
        if (scrollView.panGestureRecognizer.state == .ended ||
            scrollView.panGestureRecognizer.state == .possible) {
           return
        }
        
        // If you stopped the transition, restart it:
        if (interactionController.state != .isInteracting) {
            self.scrollViewWillBeginDragging(scrollView, vertically: vertically)
            return
        }
        
        // Otherwise, just adjust the transition:
        let offset = vertically ? scrollView.contentOffset.y : scrollView.contentOffset.x
//        print("scrollViewDidScroll with startOffset: \(interactionController.startOffset), currentOffset: \(offset)")
        interactionController.headerDidScroll(offset: offset, width: scrollView.bounds.width)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>, vertically: Bool) {
        // MARK: Interactive Transitioning Code
        let offset = vertically ? targetContentOffset.pointee.y : targetContentOffset.pointee.x
        interactionController.headerEndedScroll(with: offset)
    }
    
    // Transition Fixed
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView, vertically: Bool) {
        interactionController.headerShouldAdjustIndices() { finished in
            if finished {
//                print("SUCCESFULL")
                if vertically {
                    self.fromSection = self.toSection
                } else {
//                    print("Setting current row fromRow: \(self.fromRow) toRow: \(self.toRow)\n")
                    self.fromRow = self.toRow
                    self.lastPage[self.fromSection] = self.fromRow
                }
            } else {
//                print("CANCELLED")
//                print("Cancelling the stuff fromRow: \(self.fromRow) toRow: \(self.toRow)\n")
                self.fromRow = self.lastPage[self.fromSection]
                self.toRow   = self.lastPage[self.fromSection]
            }
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
        self.interactionController.animator = animationController
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
