//
//  ControllerScrollView.swift
//  CollectionViewTest
//
//  Created by Youssef Victor on 12/29/17.
//  Copyright © 2017 Youssef Victor. All rights reserved.
//

import Foundation
import UIKit

class ControllersCollectionView : UICollectionView, UICollectionViewDelegateFlowLayout {
    fileprivate let controllerCellId = "controllerCellId"
    fileprivate var sectionNumber : Int?
    
    init(frame: CGRect) {
        // Initialize the view's Layout
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        
        super.init(frame: frame, collectionViewLayout: flowLayout)
        
        // Setup Stuff
        self.delegate        = self
        self.dataSource      = self
        self.clipsToBounds   = true
        self.isPagingEnabled = true
        self.backgroundColor = UIColor.clear
        
        // Register Cell (Insted of doing this in storyboard)
        self.register(CrossConControllerCell.self, forCellWithReuseIdentifier: self.controllerCellId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setSectionNumber(_ sectionNumber: Int) {
        self.sectionNumber = sectionNumber
    }
    
}

extension ControllersCollectionView : UICollectionViewDataSource {
    //
    // MARK: CollectionViewDataSourceDelegate functions
    //
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Setup the larger collectionView's cell which is just a scrollable row
        let sectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.controllerCellId, for: indexPath) as! CrossConControllerCell
        sectionCell.willAppear(in: self.sectionNumber!, page: indexPath.row)
        
        print("cellForItemAt#: \(indexPath)")
        
        return sectionCell
    }
    
    internal func collectionView(_ collectionView: UICollectionView,
                                 didEndDisplaying cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        let controllerCell = cell as! CrossConControllerCell
        controllerCell.didDisappear()
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: (self.frame.height))
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CrossConContainerViewController.pages[sectionNumber!].count
    }
}


// MARK: Mini-class that is basically just a ViewController
class CrossConControllerCell : UICollectionViewCell {
    
    // MARK: Constants
    let controllerCellId = "controllerCellId"
    var viewController : UIViewController?
    
    var index : IndexPath?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewController = nil
        // TODO: Remove the childViewController
        // print("CollectionViewCell at: \(index ?? IndexPath(item: 99, section: 99)) is being reused")
    }
    
    fileprivate func willAppear(in section: Int, page: Int) {
        if (viewController == nil) {
            setupPage(in: section, page: page)
        //    print("CollectionViewCell at: \(index ?? IndexPath(item: 99, section: 99)) is being initialized")
        }
        
        // TODO: ViewDidLoad Stuff (add ChildViewController
        //print("CollectionViewCell at: \(index ?? IndexPath(item: 99, section: 99)) is appearing!")
    }
    
    fileprivate func didDisappear() {
        self.viewController!.viewDidDisappear(false)
    }
    
    private func setupPage(in section: Int, page: Int) {
        // TODO: Delet this
        self.index = IndexPath(item: page, section: section)
        
        self.viewController = CrossConContainerViewController.pages[section][page]
        let view = self.viewController!.view!
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalTo: self.heightAnchor),
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.leftAnchor.constraint(equalTo: self.leftAnchor),
            view.rightAnchor.constraint(equalTo: self.rightAnchor),
            ])
    }
}







