//
//  PageController.swift
//  SwipeNavigationView
//
//  Created by Milan Nosáľ on 21/01/2018.
//  Copyright © 2018 Youssef Victor. All rights reserved.
//

import UIKit

class PageController: UIViewController {
    
    let pageTitle: String
    
    let backColor: UIColor
    
    init(title: String, color: UIColor) {
        self.backColor = color
        self.pageTitle = title
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backColor
        switch (backColor) {
        case .red:
            print("RED    ViewController loaded")
        case .green:
            print("GREEN  ViewController loaded")
        case .orange:
            print("ORANGE ViewController loaded")
        case .cyan:
            print("CYAN   ViewController loaded")
        case .yellow:
            print("YELLOW ViewController loaded")
        case .brown:
            print("BROWN  ViewController loaded")
        case .white:
            print("WHITE  ViewController loaded")
        case .blue:
            print("BLUE   ViewController loaded")
        default:
            print("UNKNOWN COLOR")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch (backColor) {
        case .red:
            print("RED    ViewController willAppear")
        case .green:
            print("GREEN  ViewController willAppear")
        case .orange:
            print("ORANGE ViewController willAppear")
        case .cyan:
            print("CYAN   ViewController willAppear")
        case .yellow:
            print("YELLOW ViewController willAppear")
        case .brown:
            print("BROWN  ViewController willAppear")
        case .white:
            print("WHITE  ViewController willAppear")
        case .blue:
            print("BLUE   ViewController willAppear")
        default:
            print("UNKNOWN COLOR")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        switch (backColor) {
        case .red:
            print("RED    ViewController willDisappear")
        case .green:
            print("GREEN  ViewController willDisappear")
        case .orange:
            print("ORANGE ViewController willDisappear")
        case .cyan:
            print("CYAN   ViewController willDisappear")
        case .yellow:
            print("YELLOW ViewController willDisappear")
        case .brown:
            print("BROWN  ViewController willDisappear")
        case .white:
            print("WHITE  ViewController willDisappear")
        case .blue:
            print("BLUE   ViewController willDisappear")
        default:
            print("UNKNOWN COLOR")
        }
    }
}
