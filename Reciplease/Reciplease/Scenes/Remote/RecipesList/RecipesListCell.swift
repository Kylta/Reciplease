//
//  RecipesListCell.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 22/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import UIKit

class RecipesListCell: UITableViewCell, RecipesListCellView {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet var ratesImageView: [UIImageView]!
    @IBOutlet weak var timeLabel: UILabel!

    func display(recipeImageUrl: String) {
        backgroundImageView?.downloadedFrom(link: recipeImageUrl)
    }

    func display(recipeName: String) {
        nameLabel.text = recipeName
    }

    func display(recipesIngredients: String) {
        ingredientsLabel.text = recipesIngredients
    }

    func display(rating: Int) {
        ratesImageView.forEach { if $0.tag <= rating { $0.image = #imageLiteral(resourceName: "yellow star") } }
    }

    func display(time: String) {
        timeLabel.text = time
    }
}
