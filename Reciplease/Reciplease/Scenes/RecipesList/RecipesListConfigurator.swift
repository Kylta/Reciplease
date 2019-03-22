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
    let recipes: [Recipe]

    init(recipes: [Recipe]) {
        self.recipes = recipes
    }

    func configure(recipesListController: RecipesListController) {

    }
}
