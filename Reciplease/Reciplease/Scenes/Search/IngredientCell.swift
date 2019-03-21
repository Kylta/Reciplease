//
//  IngredientCell.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 21/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import UIKit

class IngredientCell: UITableViewCell, IngredientCellView {
    @IBOutlet weak var ingredientLabel: UILabel!

    func display(ingredient: String) {
        ingredientLabel.text = ingredient
    }
}
