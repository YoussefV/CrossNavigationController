//
//  ViewController.swift
//  CollectionViewTest
//
//  Created by Youssef Victor on 12/28/17.
//  Copyright © 2017 Youssef Victor. All rights reserved.
//


import UIKit

class InteractiveContainerViewController: InteractiveTransitioningContainer {
    
    let headerView: HeaderView = HeaderView(frame: CGRect.zero)
    
    //fileprivate var interactionController: SwipeGestureInteractiveTransition!
    
    open override func loadView() {
        super.loadView()
        
        self.containerView = UIView()
        self.view.addSubview(containerView)
        
        self.containerDelegate = headerView
        
        headerView.container = self
        self.view.addSubview(headerView)
        headerView.backgroundColor = .white
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(equalToConstant: 75),
            headerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0),
            headerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            
            containerView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
    }
}

//extension UIView {
//    func fillSuperview() {
//        self.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.superview!, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
//        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.superview!, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
//        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.superview!, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
//        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.superview!, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
//    }
//}

