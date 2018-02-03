//
//  HeaderViewScrollDelegate.swift
//  SwipeNavigationView
//
//  Created by Youssef Victor on 1/21/18.
//  Copyright © 2018 Youssef Victor. All rights reserved.
//

import Foundation
import UIKit

protocol CrossConHeaderViewScrollDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView, vertically: Bool)
    
    func scrollViewDidScroll(_ scrollView: UIScrollView, vertically: Bool)
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>, vertically: Bool)
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView, vertically: Bool)
}

protocol CrossConTransitionDelegate {

    func startTransition(vertically : Bool, positive : Bool)
    
    func updateTransition(with progress: CGFloat, vertically: Bool)
    
    func completeTransition(to newIndex: IndexPath)
    
}
