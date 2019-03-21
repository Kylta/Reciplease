//
//  DisplayRecipesList.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 21/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

typealias DisplayRecipesUseCaseCompletionHandler = (_ recipes: Result<[Recipe]>) -> Void

protocol DisplayRecipesUseCase {
    func displayRecipes(completionHandler: @escaping DisplayRecipesUseCaseCompletionHandler)
}

class DisplayRecipesListUseCaseImplementation: DisplayRecipesUseCase {
    let recipesGateway: RecipesGateway

    init(recipeGateway: RecipesGateway) {
        self.recipesGateway = recipeGateway
    }

    // MARK: - DisplayRecipesUseCase

    func displayRecipes(completionHandler: @escaping DisplayRecipesUseCaseCompletionHandler) {
        self.recipesGateway.fetchRecipes { result in
            completionHandler(result)
        }
    }
}
