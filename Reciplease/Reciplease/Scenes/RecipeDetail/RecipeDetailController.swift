//
//  RecipeDetailController.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 22/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import UIKit

class RecipeDetailController: UIViewController, RecipeDetailView {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var ratingImageView: [UIImageView]!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    var presenter: RecipeDetailPresenter!
    var configurator: RecipeDetailConfiguratorImplementation!

    override func viewDidLoad() {
        super.viewDidLoad()

        ingredientsTableView.register(IngredientCell.self)

        configurator.configure(recipeDetailsController: self)
        presenter.viewDidLoad()
    }

    func display(recipeImageUrl: String) {
        backgroundImage.downloadedFrom(link: recipeImageUrl)
    }

    func display(recipeName: String) {
        recipeNameLabel.text = recipeName
    }

    func display(rating: Int) {
        ratingImageView.forEach { if $0.tag <= rating { $0.image = #imageLiteral(resourceName: "yellow star") } }
    }

    func display(time: String) {
        timeLabel.text = time
    }
}

extension RecipeDetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfIngredients
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(IngredientCell.self)!
        presenter.configure(cell: cell, forRow: indexPath.row)
        return cell
    }
}
