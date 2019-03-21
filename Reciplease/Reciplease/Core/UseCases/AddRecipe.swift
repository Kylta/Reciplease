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
    func add(parameters: AddRecipeParameters, completionHandler: @escaping AddRecipeUseCaseCompletionHandler)
}

struct AddRecipeParameters {
    let name: String
    let ingredients: [String]
    let id: String?
    let rate: Int
    let time: Int
    let imageURL: String
}

class AddRecipeUseCaseImplementation: AddRecipeUseCase {
    let recipesGateway: RecipesGateway

    init(recipesGateway: RecipesGateway) {
        self.recipesGateway = recipesGateway
    }

    // MARK: - AddRecipeUseCase

    func add(parameters: AddRecipeParameters, completionHandler: @escaping AddRecipeUseCaseCompletionHandler) {
        self.recipesGateway.add(parameters: parameters) { result in
            completionHandler(result)
        }
    }
}
