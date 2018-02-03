//
//  HeaderViewTransitionDelegate.swift
//  SwipeNavigationView
//
//  Created by Youssef Victor on 1/29/18.
//  Copyright © 2018 Youssef Victor. All rights reserved.
//

import Foundation
import UIKit

class CrossConTransitioner : CrossConTransitionDelegate {

    // MARK: Public Variables
    // A View containing the viewcontrollers to move
    let viewControllersView : CrossConControllersView
    
    // MARK: Private Variables
    var indexPath : IndexPath = IndexPath(item: 0, section: 0)
    
    init(with viewControllersView: CrossConControllersView) {
        self.viewControllersView = viewControllersView
    }
    
    
    func startTransition(vertically: Bool, positive: Bool) {
        print("STARTING TRANSITION. isVertical: \(vertically), isPositive: \(positive)")
    }
    
    func updateTransition(with progress: CGFloat, vertically: Bool) {
       self.viewControllersView.scrollController(rowIndexPath: self.indexPath,
                                                 offsetRatio: progress,
                                                 vertically: vertically)
    }
    
    func completeTransition(to newIndex: IndexPath) {
        self.indexPath = newIndex
        print("TRANSITION DONE")
    }
    
}
