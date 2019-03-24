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
        let recipeNutritions = recipeDetails?.nutritions?.allObjects as? [CoreDataRecipeNutritions]
        let recipeNutritionsMapped = recipeNutritions.map { $0.map { RecipeNutritions(value: $0.value ,
                                                                                      name: $0.name ?? "",
                                                                                      abbreviation: $0.abbreviation ?? "",
                                                                                      plural: $0.abbreviation ?? "",
                                                                                      pluralAbbreviation: $0.pluralAbbreviation ?? "") } }!

        let details = RecipeDetail(name: recipeDetails?.name ?? "",
                                   ingredients: recipeDetails?.ingredients ?? [],
                                   rate: Int(recipeDetails?.rate ?? 0),
                                   time: Int(recipeDetails?.time ?? 0),
                                   imageURL: recipeDetails?.imageURL ?? "",
                                   recipeURL: recipeDetails?.recipeURL ?? "",
                                   nutritions: recipeNutritionsMapped)
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
                            imageURL: imageURL ?? "",
                            recipeURL: recipeURL ?? "",
                            nutritions: nutritions?.allObjects as! [RecipeNutritions])
    }

    func populate(with parameters: AddRecipeDetailParameters) {
        name = parameters.name
        ingredients = parameters.ingredients
        rate = Int32(parameters.rate)
        time = Int32(parameters.time)
        imageURL = parameters.imageURL
        recipeURL = parameters.recipeURL
    }

    func populate(with recipeDetail: RecipeDetail) {
        name = recipeDetail.name
        ingredients = recipeDetail.ingredients
        rate = Int32(recipeDetail.rate)
        time = Int32(recipeDetail.time)
        imageURL = recipeDetail.imageURL
        recipeURL = recipeDetail.recipeURL
    }
}

extension CoreDataRecipeNutritions {
    var recipeNutritions: RecipeNutritions {
        return RecipeNutritions(value: value,
                                name: name ?? "",
                                abbreviation: abbreviation ?? "",
                                plural: plural ?? "",
                                pluralAbbreviation: pluralAbbreviation ?? ""
        )
    }

    func populate(with parameters: AddRecipeNutritionsParameters) {
        value = parameters.value
        name = parameters.name
        abbreviation = parameters.abbreviation
        plural = parameters.plural
        pluralAbbreviation = parameters.pluralAbbreviation
    }

    func populate(with recipeDetail: RecipeNutritions) {
        value = recipeDetail.value
        name = recipeDetail.name
        abbreviation = recipeDetail.abbreviation
        plural = recipeDetail.plural
        pluralAbbreviation = recipeDetail.pluralAbbreviation
    }
}
