//
//  RecipeDetailLocalConfigurator.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 22/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

class RecipeDetailLocalConfiguratorImplementation: RecipeDetailConfigurator {
    let recipe: Recipe

    init(recipe: Recipe) {
        self.recipe = recipe
    }

    func configure(recipeDetailView: RecipeDetailView) {

        let viewContext = CoreDataStackImplementation.sharedInstance.persistentContainer.viewContext
        let recipesGateway = CoreDataRecipesGateway(viewContext: viewContext)
        let addRecipeUseCase = AddRecipeUseCaseImplementation(recipesGateway: recipesGateway)
        let deleteRecipeUseCase = DeleteRecipeUseCaseImplementation(recipeGateway: recipesGateway)
        let displayRecipeUseCase = DisplayRecipesListUseCaseImplementation(recipeGateway: recipesGateway)
        let recipeDetailController = recipeDetailView as! RecipeDetailLocalController
        let router = RecipeDetailLocalViewRouterImplementation(view: recipeDetailController)
        let presenter = RecipeDetailLocalPresenterImplementation(view: recipeDetailController, addRecipeUseCase: addRecipeUseCase, displayRecipesUseCase: displayRecipeUseCase, deleteRecipeUseCase: deleteRecipeUseCase, router: router, recipe: recipe)
        recipeDetailController.presenter = presenter
    }
}
