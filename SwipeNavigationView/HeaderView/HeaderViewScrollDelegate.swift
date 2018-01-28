//
//  HeaderViewScrollDelegate.swift
//  SwipeNavigationView
//
//  Created by Youssef Victor on 1/21/18.
//  Copyright © 2018 Youssef Victor. All rights reserved.
//

import Foundation
import UIKit

protocol HeaderViewScrollDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView, vertically: Bool)
    
    func scrollViewDidScroll(_ scrollView: UIScrollView, vertically: Bool)
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>, vertically: Bool)
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView, vertically: Bool)
}
