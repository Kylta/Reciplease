//
//  CoreDataRecipe.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 21/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation
import CoreData

extension CoreDataRecipe {
    var recipe: Recipe {
        return Recipe(name: name ?? "",
                      ingredients: ingredients ?? [],
                      id: id,
                      rate: Int(rate),
                      time: Int(time),
                      imageURL: imageURL ?? "",
                      detail: nil)
    }

    func populate(with parameters: AddRecipeParameters) {
        name = parameters.name
        ingredients = parameters.ingredients
        id = parameters.id
        rate = Int32(parameters.rate)
        time = Int32(parameters.time)
        imageURL = parameters.imageURL
//        detail = parameters.detail
    }

    func populate(with recipe: Recipe) {
        name = recipe.name
        ingredients = recipe.ingredients
        id = recipe.id
        rate = Int32(recipe.rate)
        time = Int32(recipe.time)
        imageURL = recipe.imageURL
    }
}
