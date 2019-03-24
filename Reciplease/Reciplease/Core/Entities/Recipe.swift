//
//  Recipe.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 21/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

struct Recipe: Equatable {
    let name: String
    let ingredients: [String]
    let id: String?
    let rate: Int
    let time: Int
    let imageURL: String
    var details: RecipeDetail?

    init(name: String, ingredients: [String], id: String?, rate: Int, time: Int, imageURL: String, details: RecipeDetail?) {
        self.name = name
        self.ingredients = ingredients
        self.id = id
        self.rate = rate
        self.time = time
        self.imageURL = imageURL
        self.details = details
    }
}

struct RecipeDetail: Equatable {
    let name: String
    let ingredients: [String]
    let rate: Int
    let time: Int
    let imageURL: String
    let recipeURL: String
    let nutritions: [RecipeNutritions]
}

struct RecipeNutritions: Equatable {
    let value: Double
    let name: String
    let abbreviation: String
    let plural: String
    let pluralAbbreviation: String
}
