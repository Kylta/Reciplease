//
//  Recipe.swift
//  RecipleaseTests
//
//  Created by Christophe Bugnon on 25/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation
@testable import Reciplease

extension Recipe {
    static func createRecipesArray(numberOfElements: Int = 2) -> [Recipe] {
        var recipes = [Recipe]()

        for i in 0..<numberOfElements {
            let recipe = createRecipe(index: i)
            recipes.append(recipe)
        }

        return recipes
    }

    static func createRecipe(index: Int = 0) -> Recipe {
        return Recipe(name: "Name: \(index)",
            ingredients: ["Ingredient: \(index)"],
            id: "ID \(index)",
            rate: index,
            time: index,
            imageURL: "ImageURL: \(index)",
            details: nil)
    }
}
