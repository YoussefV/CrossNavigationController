//
//  HeaderViewViewControllerScroller.swift
//  SwipeNavigationView
//
//  Created by Youssef Victor on 1/29/18.
//  Copyright © 2018 Youssef Victor. All rights reserved.
//

import UIKit

class CrossConControllersView: UICollectionView, UICollectionViewDelegateFlowLayout {
    
    // Pseudocode:
    //   - .isUserInteractionEnabled = false
    //   - .isDirectionalLockEnabled = true (Do you really need it?)
    //
    //
    
    private let controllersCellId = "controllerCellId"
    
    // DONE
    // DONE
    // DONE
    // DONE
    // TODO:  5 - Connect to the HeaderViewController
    // 
    //

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
        self.register(CrossConControllersSectionCell.self, forCellWithReuseIdentifier: controllersCellId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
    
extension CrossConControllersView : UICollectionViewDataSource {
    //
    // MARK: CollectionViewDataSourceDelegate functions
    //
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Setup the larger collectionView's cell which is just a scrollable row
        let sectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.controllersCellId, for: indexPath) as! CrossConControllersSectionCell
        sectionCell.setupSection(for: indexPath.row)
        
        return sectionCell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: (self.frame.height))
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CrossConContainerViewController.pages.count
    }
}


extension CrossConControllersView {
    //
    // MARK: CollectionViewDataSourceDelegate functions
    //
    
    // This function takes in the rowIndexPath and uses its section as a row to
    // index into the correct row cell in a CrossConControllersView
    func scrollController(rowIndexPath: IndexPath, offsetRatio: CGFloat, vertically: Bool) {
        if vertically {
            // Move the Controllers vertically
            let offset = CGPoint(x: 0, y: self.frame.height * offsetRatio)
            self.setContentOffset(offset, animated: false)
        } else {
            // Move the Controllers horizontally
            // We get the cell in the collection view to scroll horizontally
            let sectionCell = self.cellForItem(at: IndexPath(item: rowIndexPath.section, section: 0)) as! CrossConControllersSectionCell
            
            let offset = CGPoint(x: sectionCell.frame.width * offsetRatio, y: 0)
            
            sectionCell.scrollView.setContentOffset(offset, animated: false)
        }
    }
    
    
    
}




