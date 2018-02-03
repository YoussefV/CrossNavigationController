//
//  ViewController.swift
//  CollectionViewTest
//
//  Created by Youssef Victor on 12/28/17.
//  Copyright © 2017 Youssef Victor. All rights reserved.
//


import UIKit

class CrossConContainerViewController : UIViewController {
    
    let headerView: CrossConHeaderView = CrossConHeaderView(frame: .zero)
    
    let controllersView : CrossConControllersView = CrossConControllersView(frame: .zero)
    
    lazy var transitioner : CrossConTransitioner  = CrossConTransitioner(with: controllersView)
    
    // Pages
    static let pages = [[PageController(title: "Sect0-Page0", color: .green), PageController(title: "Sect0-Page1", color: .red), PageController(title: "Sect0-Page2", color: .orange)],
                        [PageController(title: "Sect1-Page0", color: .cyan), PageController(title: "Sect0-Page1", color: .yellow)]]
    
    open override func loadView() {
        super.loadView()
        
        self.view.addSubview(headerView)
        headerView.backgroundColor = .white
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.transitionDelegate = transitioner
        
        // Add all the childViewControllers
        CrossConContainerViewController.pages.forEach({section in section.forEach({page in self.addChildViewController(page)})})
        
        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(equalToConstant: 75),
            headerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0),
            headerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
        ])
        
        self.view.addSubview(controllersView)
        controllersView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controllersView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor),
            controllersView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            controllersView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            controllersView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
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

