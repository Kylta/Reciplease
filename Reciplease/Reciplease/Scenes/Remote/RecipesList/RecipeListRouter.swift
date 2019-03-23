//
//  RecipeListRouter.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 22/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import UIKit

protocol RecipesListViewRouter: ViewRouter {
    func presentRecipeDetailView(for recipe: Recipe)
    func dismiss()
}

class RecipesListRouterImplementation: RecipesListViewRouter {
    fileprivate weak var recipesListController: RecipesListController?
    fileprivate var recipe: Recipe!

    init(recipesListController: RecipesListController) {
        self.recipesListController = recipesListController
    }

    // MARK: - RecipesListRouter

    func dismiss() {
        recipesListController?.navigationController?.dismiss(animated: true, completion: nil)
    }

    func presentRecipeDetailView(for recipe: Recipe) {
        self.recipe = recipe
        recipesListController?.performSegue(withIdentifier: "RecipesListSceneToRecipeDetailSceneSegue", sender: nil)
    }

    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recipeDetailController = segue.destination as? RecipeDetailController {
            recipeDetailController.configurator = RecipeDetailConfiguratorImplementation(recipe: recipe)
        }
    }
}
