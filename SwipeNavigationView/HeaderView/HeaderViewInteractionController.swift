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
    
    private let velocityNeeded: CGFloat
    
    private var lastVelocity = CGPoint.zero
    
    private var startOffset   : CGFloat = 0.0
    private var triggerOffset : CGFloat = 0.0
    
    private var positiveTransition = false
    private var verticalTransition = false
    
    private var recognizedBlock : (() -> ())
    
    private var shouldCompleteTransition = false
    
    init(progressThreshold: CGFloat = 0.35, velocityOverrideThreshold: CGFloat = 550) {
        self.progressNeeded = progressThreshold
        self.velocityNeeded = velocityOverrideThreshold
        self.recognizedBlock = {}
        super.init()
    }
    
    func setTransitionValues(startOffset: CGFloat, velocity: CGFloat, width: CGFloat, vertically: Bool, recognizedBlock: @escaping (() -> ())) {
        self.startOffset        = startOffset
        self.triggerOffset      = fabs(width * progressNeeded)
        self.positiveTransition = velocity >= 0
        self.verticalTransition = vertically
        self.recognizedBlock    = recognizedBlock
    }
    
    func headerDidScroll(offset: CGFloat, width: CGFloat, velocity : CGFloat = 0) {
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
        
        // This code checks if we came back to starting point, and if yes,
        // we cancel the current transition
        if (positiveTransition && translation < 0) ||
           (!positiveTransition && translation > 0) {
            
            self.shouldCompleteTransition = false
            self.updateInteractiveTransition(percentComplete: 0)
            self.cancelInteractiveTransition()
            return
        }
        
        let progress = translation / width
        
        // Decision if we came far enough to complete the transition automatically even
        // if we finish pan gesture
        self.shouldCompleteTransition = fabs(translation) > triggerOffset || fabs(velocity) > velocityNeeded
        
        self.updateInteractiveTransition(percentComplete: progress)
    }
    
    func headerEndedScroll() {
        guard transitionContext != nil, state != .isInTearDown else {
            return
        }
        
        if shouldCompleteTransition {
            self.finishInteractiveTransition()
        } else {
            self.cancelInteractiveTransition()
        }
        shouldCompleteTransition = false
    }
    
    
}
