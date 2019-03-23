//
//  RecipeListLocalRouter.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 22/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import UIKit

class RecipesListLocalRouterImplementation: RecipesListViewRouter {
    fileprivate weak var recipesListController: RecipesListLocalController?
    fileprivate var recipe: Recipe!

    init(recipesListLocalController: RecipesListLocalController) {
        self.recipesListController = recipesListLocalController
    }

    // MARK: - RecipesListRouter

    func dismiss() { }

    func presentRecipeDetailView(for recipeDetail: RecipeDetail) {
        self.recipe.detail = recipeDetail
        recipesListController?.performSegue(withIdentifier: "RecipesListLocalSceneToRecipeDetailLocalSceneSegue", sender: nil)
    }

    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recipeDetailController = segue.destination as? RecipeDetailLocalController {
            recipeDetailController.configurator = RecipeDetailLocalConfiguratorImplementation(recipe: recipe)
        }
    }
}
