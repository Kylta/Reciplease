//
//  NutritionCell.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 24/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import UIKit

class NutritionCell: UITableViewCell, NutritionCellView {
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var abbreviationLabel: UILabel!

    func display(name: String) {
        nameLabel.text = name
    }

    func display(abbreviation: String) {
        abbreviationLabel.text = abbreviation
    }

    func display(value: String) {
        valueLabel.text = value
    }

    func display(description: String) {

    }
}
