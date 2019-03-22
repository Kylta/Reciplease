//
//  RecipeDetailConfigurator.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 22/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

protocol RecipeDetailConfigurator {
    func configure(recipeDetailsController: RecipeDetailController)
}

class RecipeDetailConfiguratorImplementation: RecipeDetailConfigurator {
    let recipe: Recipe

    init(recipe: Recipe) {
        self.recipe = recipe
    }

    func configure(recipeDetailsController: RecipeDetailController) {
        let presenter = RecipeDetailPresenterImplementation(view: recipeDetailsController, recipe: recipe)
        recipeDetailsController.presenter = presenter
    }
}

