//
//  RecipeListRouter.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 22/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

protocol RecipesListViewRouter: ViewRouter {
    func dismiss()
}

class RecipesListRouterImplementation: RecipesListViewRouter {
    fileprivate weak var recipesListController: RecipesListController?

    init(recipesListController: RecipesListController) {
        self.recipesListController = recipesListController
    }

    // MARK: - RecipesListRouter

    func dismiss() {
        recipesListController?.navigationController?.dismiss(animated: true, completion: nil)
    }
}
