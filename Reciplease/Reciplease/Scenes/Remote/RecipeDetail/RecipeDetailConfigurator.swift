//
//  RecipeDetailConfigurator.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 22/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

protocol RecipeDetailConfigurator {
    func configure(recipeDetailView: RecipeDetailView)
}

class RecipeDetailConfiguratorImplementation: RecipeDetailConfigurator {
    let recipeDetail: RecipeDetail

    init(recipeDetail: RecipeDetail) {
        self.recipeDetail = recipeDetail
    }

    func configure(recipeDetailView: RecipeDetailView) {

        let viewContext = CoreDataStackImplementation.sharedInstance.persistentContainer.viewContext
        let recipesGateway = CoreDataRecipesGateway(viewContext: viewContext)
        let addRecipeUseCase = AddRecipeUseCaseImplementation(recipesGateway: recipesGateway)
        let displayRecipeUseCase = DisplayRecipesListUseCaseImplementation(recipeGateway: recipesGateway)
        let recipeDetailController = recipeDetailView as! RecipeDetailController
        let presenter = RecipeDetailPresenterImplementation(view: recipeDetailController, addRecipeUseCase: addRecipeUseCase, displayRecipesUseCase: displayRecipeUseCase, recipeDetail: recipeDetail)
        recipeDetailController.presenter = presenter
    }
}

