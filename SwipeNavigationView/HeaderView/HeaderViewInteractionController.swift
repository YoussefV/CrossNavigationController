//
//  HeaderViewInteractionController.swift
//  SwipeNavigationView
//
//  Created by Youssef Victor on 1/24/18.
//  Copyright © 2018 Youssef Victor. All rights reserved.
//

import Foundation
import UIKit

// MARK: Interactive Transitioning Code

class HeaderViewInteractionController : InteractiveTransitionContainerAnimatorBasedPercentDrivenInteractiveTransition {
    private let progressNeeded: CGFloat
    
    // FIXME: Turn startoffset private
    var startOffset   : CGFloat = 0.0
    private var triggerOffset : CGFloat = 0.0
    
    private var positiveTransition = false
    private var verticalTransition = false
    
    private var recognizedBlock : (() -> ())
    
    private var shouldAdjustIndices = false
    
    init(progressThreshold: CGFloat = 0.35) {
        self.progressNeeded = progressThreshold
        self.recognizedBlock = {}
        super.init()
    }
    
    func setTransitionValues(startOffset: CGFloat, velocity: CGFloat, width: CGFloat, vertically: Bool, recognizedBlock: @escaping (() -> ())) {
        self.startOffset        = startOffset
        self.positiveTransition = velocity >= 0
        self.triggerOffset      = startOffset
        triggerOffset -= positiveTransition ? width/2.0 : -width/2.0
        self.verticalTransition = vertically
        self.recognizedBlock    = recognizedBlock
    }
    
    func headerDidScroll(offset: CGFloat, width: CGFloat) {
        // comming back to initial position in screen can cancel current animation
        // and we need ignore those changes
        guard state != .isInTearDown else {
            return
        }
        
        // Now if it was cancelled and torn down, but panning continues, we restart it
        guard state == .isInteracting else {
            recognizedBlock()
            return
        }
        
        guard transitionContext != nil else {
            // transition context has to exist for us to perform transition
            fatalError()
        }
        
        
        let translation = offset - startOffset
        
        let progress =  fabs(translation) / width
        
        // This code checks if we came back to starting point, and if yes,
        // we cancel the current transition
        if (positiveTransition && translation > 0) ||
           (!positiveTransition && translation < 0 ||
            progress > 1) {
            self.updateInteractiveTransition(percentComplete: 0)
            self.cancelInteractiveTransition()
            return
        }
        
        if (progress > 1.0) {
            print("GREATER THAN ONE")
        }
        
        // Decision if we came far enough to complete the transition automatically even
        // if we finish pan gesture
        
        //print("Is positive: \(positiveTransition), translation: \(translation)")
        //print("Updating transition with progress of: \(progress)")
        
        self.updateInteractiveTransition(percentComplete: progress)
    }
    
    func headerEndedScroll(with targetContentOffset: CGFloat) {
        guard transitionContext != nil, state != .isInTearDown else {
            return
        }
        
        //print("StartingOffset is: \(startOffset), targetOffset is: \(targetContentOffset)")
        
        let willCompleteTransition = (targetContentOffset <= triggerOffset && positiveTransition) ||
                                     (targetContentOffset >= triggerOffset && !positiveTransition)
        
        if willCompleteTransition {
            self.finishInteractiveTransition()
        } else {
            self.cancelInteractiveTransition()
        }
        
        shouldAdjustIndices = willCompleteTransition
    }
    
    func headerShouldAdjustIndices(_ completion : @escaping (Bool) -> ()) {
        completion(shouldAdjustIndices)
        shouldAdjustIndices = false
    }
    
    
}
