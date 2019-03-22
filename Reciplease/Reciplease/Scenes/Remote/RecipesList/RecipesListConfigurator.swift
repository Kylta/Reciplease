//
//  RecipesListConfigurator.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 22/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

protocol RecipesListConfigurator {
    func configure(recipesListController: RecipesListController)
}

class RecipesListConfiguratorImplementation: RecipesListConfigurator {
    var recipesListPresenterDelegate: RecipesListPresenterDelegate?

    let recipes: [Recipe]

    init(recipes: [Recipe],
         delegate: RecipesListPresenterDelegate?) {
        self.recipes = recipes
        self.recipesListPresenterDelegate = delegate
    }

    func configure(recipesListController: RecipesListController) {
        let router = RecipesListRouterImplementation(recipesListController: recipesListController)

        let presenter = RecipesListPresenterImplementation(view: recipesListController, recipes: recipes, delegate: recipesListPresenterDelegate, router: router)

        recipesListController.presenter = presenter
    }
}
