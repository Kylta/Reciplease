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
        let details = RecipeDetail(name: recipeDetails?.name ?? "",
                                   ingredients: recipeDetails?.ingredients ?? [],
                                   rate: Int(recipeDetails?.rate ?? 0),
                                   time: Int(recipeDetails?.time ?? 0),
                                   imageURL: recipeDetails?.imageURL ?? "")
        return Recipe(name: name ?? "",
                      ingredients: ingredients ?? [],
                      id: id,
                      rate: Int(rate),
                      time: Int(time),
                      imageURL: imageURL ?? "",
                      details: details)
    }

    func populate(with parameters: AddRecipeParameters) {
        name = parameters.name
        ingredients = parameters.ingredients
        id = parameters.id
        rate = Int32(parameters.rate)
        time = Int32(parameters.time)
        imageURL = parameters.imageURL
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

extension CoreDataRecipeDetails {
     var recipeDetails: RecipeDetail {
        return RecipeDetail(name: name ?? "",
                            ingredients: ingredients ?? [],
                            rate: Int(rate), time: Int(time),
                            imageURL: imageURL ?? "")
    }

    func populate(with parameters: AddRecipeDetailParameters) {
        name = parameters.name
        ingredients = parameters.ingredients
        rate = Int32(parameters.rate)
        time = Int32(parameters.time)
        imageURL = parameters.imageURL
    }

    func populate(with recipeDetail: RecipeDetail) {
        name = recipeDetail.name
        ingredients = recipeDetail.ingredients
        rate = Int32(recipeDetail.rate)
        time = Int32(recipeDetail.time)
        imageURL = recipeDetail.imageURL
    }
}
