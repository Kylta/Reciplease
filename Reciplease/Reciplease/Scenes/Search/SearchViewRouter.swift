//
//  SearchViewRouter.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 22/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import UIKit

protocol SearchViewRouter: ViewRouter {
    func presentRecipesListView(for recipes: [Recipe])
}

class SeachViewRouterImplementation: SearchViewRouter {
    fileprivate weak var searchController: SearchController?
    fileprivate var recipes = [Recipe]()

    init(searchController: SearchController) {
        self.searchController = searchController
    }

    // MARK: - SearchViewRouter

    func presentRecipesListView(for recipes: [Recipe]) {
        self.recipes = recipes
        searchController?.performSegue(withIdentifier: "SearchSceneToRecipesListSceneSegue", sender: nil)
    }

    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recipesListController = segue.destination as? RecipesListController {
            recipesListController.configurator = RecipesListConfiguratorImplementation(recipes: recipes)
        }
    }
}
