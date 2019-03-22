//
//  SearchViewRouter.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 22/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import UIKit

protocol SearchViewRouter: ViewRouter {
    func presentRecipesListView(for recipes: [Recipe], recipesListPresenterDelegate: RecipesListPresenterDelegate)
}

class SeachViewRouterImplementation: SearchViewRouter {
    fileprivate weak var searchController: SearchController?
    fileprivate weak var recipesListPresenterDelegate: RecipesListPresenterDelegate?
    fileprivate var recipes = [Recipe]()

    init(searchController: SearchController) {
        self.searchController = searchController
    }

    // MARK: - SearchViewRouter

    func presentRecipesListView(for recipes: [Recipe], recipesListPresenterDelegate: RecipesListPresenterDelegate) {
        self.recipesListPresenterDelegate = recipesListPresenterDelegate
        self.recipes = recipes
        searchController?.performSegue(withIdentifier: "SearchSceneToRecipesListSceneSegue", sender: nil)
    }

    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController,
            let recipesListController = navigationController.topViewController as? RecipesListController {
            recipesListController.configurator = RecipesListConfiguratorImplementation(recipes: recipes, delegate: recipesListPresenterDelegate)
        }
    }
}
