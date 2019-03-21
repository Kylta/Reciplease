//
//  TabBarController.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 21/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    let attributes = [
        NSAttributedString.Key.font : UIFont(name: "chalkduster", size: 22)!,
        NSAttributedString.Key.foregroundColor : UIColor.white
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Reciplease"

        tabBar.barTintColor = UIColor(red: 55/255, green: 51/255, blue: 50/255, alpha: 1)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
    }
}
