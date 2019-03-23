//
//  AddRecipe.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 21/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

typealias AddRecipeUseCaseCompletionHandler = (_ recipes: Result<Recipe>) -> Void

protocol AddRecipeUseCase {
    func add(parameters: AddRecipeParameters, detailsParameters: AddRecipeDetailParameters, completionHandler: @escaping AddRecipeEntityGatewayCompletionHandler)
}

struct AddRecipeParameters {
    let name: String
    let ingredients: [String]
    let id: String?
    let rate: Int
    let time: Int
    let imageURL: String
}

struct AddRecipeDetailParameters {
    let name: String
    let ingredients: [String]
    let rate: Int
    let time: Int
    let imageURL: String
    let recipeURL: String
}

class AddRecipeUseCaseImplementation: AddRecipeUseCase {
    let recipesGateway: RecipesGateway

    init(recipesGateway: RecipesGateway) {
        self.recipesGateway = recipesGateway
    }

    // MARK: - AddRecipeUseCase

    func add(parameters: AddRecipeParameters, detailsParameters: AddRecipeDetailParameters, completionHandler: @escaping AddRecipeEntityGatewayCompletionHandler) {
        self.recipesGateway.add(parameters: parameters, detailsParameters: detailsParameters) { result in
            completionHandler(result)
        }
    }
}
