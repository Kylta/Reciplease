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

        let viewContext = CoreDataStackImplementation.sharedInstance.persistentContainer.viewContext
        let recipesGateway = CoreDataRecipesGateway(viewContext: viewContext)
        let addRecipeUseCase = AddRecipeUseCaseImplementation(recipesGateway: recipesGateway)
        let presenter = RecipeDetailPresenterImplementation(view: recipeDetailsController, addRecipeUseCase: addRecipeUseCase, recipe: recipe)
        recipeDetailsController.presenter = presenter
    }
}

