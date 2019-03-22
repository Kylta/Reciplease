//
//  RecipesListCell.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 22/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import UIKit

class RecipesListCell: UITableViewCell {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet var ratesImageView: [UIImageView]!
    @IBOutlet weak var timeLabel: UILabel!
}
