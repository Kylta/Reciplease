//
//  RecipesGateway.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 21/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

typealias FetchRecipesEntityGatewayCompletionHandler = (_ recipes: Result<[Recipe]>) -> Void
typealias AddRecipeEntityGatewayCompletionHandler = (_ recipe: Result<Recipe>) -> Void
typealias DeleteRecipeEntityGatewayCompletionHandler = (_ recipes: Result<Void>) -> Void


protocol RecipesGateway {
    func fetchRecipes(completionHandler: @escaping FetchRecipesEntityGatewayCompletionHandler)
    func add(parameters: AddRecipeParameters, detailsParameters: AddRecipeDetailParameters, nutritrionsParameters: [AddRecipeNutritionsParameters], completionHandler: @escaping AddRecipeEntityGatewayCompletionHandler)
    func delete(recipe: Recipe, completionHandler: @escaping DeleteRecipeEntityGatewayCompletionHandler)
}

typealias FetchRecipeDetailEntityGatewayCompletionHandler = (_ recipes: Result<RecipeDetail>) -> Void

protocol RecipeDetailGateway {
    func fetchRecipesDetail(completionHandler: @escaping FetchRecipeDetailEntityGatewayCompletionHandler)
}
