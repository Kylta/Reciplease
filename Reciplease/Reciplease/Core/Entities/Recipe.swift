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
    var detail: RecipeDetail?
}

struct RecipeDetail: Equatable {
    let name: String
    let ingredients: [String]
    let rate: Int
    let time: Int
    let imageURL: String
}
