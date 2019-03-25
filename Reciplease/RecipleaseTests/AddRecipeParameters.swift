//
//  AddRecipeParameters.swift
//  RecipleaseTests
//
//  Created by Christophe Bugnon on 25/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation
@testable import Reciplease

extension AddRecipeParameters {
    static func createParameters() -> AddRecipeParameters {
        return AddRecipeParameters(name: "name", ingredients: ["ingredients"], id: "an id", rate: 1, time: 60, imageURL: "an-url.com")
    }
    static func createParameters2() -> AddRecipeParameters {
        return AddRecipeParameters(name: "another name", ingredients: ["another ingredients"], id: "another  id", rate: 1, time: 60, imageURL: "another -url.com")
    }
}

extension AddRecipeParameters: Equatable { }

public func == (lhs: AddRecipeParameters, rhs: AddRecipeParameters) -> Bool {
    return lhs.id == rhs.id
    && lhs.imageURL == rhs.imageURL
    && lhs.ingredients == rhs.ingredients
    && lhs.name == rhs.name
    && lhs.rate == rhs.rate
    && lhs.time == rhs.time
}

extension AddRecipeDetailParameters {
    static func createParameters() -> AddRecipeDetailParameters {
        return AddRecipeDetailParameters(name: "another  name", ingredients: ["another ingredients"], rate: 1, time: 60, imageURL: "another -url.com", recipeURL: "another -recipe-url.com")
    }
    static func createParameters2() -> AddRecipeDetailParameters {
        return AddRecipeDetailParameters(name: "another name", ingredients: ["another ingredients"], rate: 1, time: 60, imageURL: "another -url.com", recipeURL: "another -recipe-url.com")
    }
}

extension AddRecipeDetailParameters: Equatable { }

public func == (lhs: AddRecipeDetailParameters, rhs: AddRecipeDetailParameters) -> Bool {
    return lhs.imageURL == rhs.imageURL
        && lhs.ingredients == rhs.ingredients
        && lhs.name == rhs.name
        && lhs.rate == rhs.rate
        && lhs.time == rhs.time
        && lhs.recipeURL == rhs.recipeURL
}

extension AddRecipeNutritionsParameters {
    static func createParameters() -> AddRecipeNutritionsParameters {
        return AddRecipeNutritionsParameters(value: 10.0, name: "another name", abbreviation: "another abbreviation", description: "another description", attribute: "another  attribute")
    }
    static func createParameters2() -> AddRecipeNutritionsParameters {
        return AddRecipeNutritionsParameters(value: 10.0, name: "another name", abbreviation: "another abbreviation", description: "another description", attribute: "another attribute")
    }
}

extension AddRecipeNutritionsParameters: Equatable { }

public func == (lhs: AddRecipeNutritionsParameters, rhs: AddRecipeNutritionsParameters) -> Bool {
    return lhs.abbreviation == rhs.abbreviation
    && lhs.attribute == rhs.attribute
    && lhs.description == rhs.description
    && lhs.name == rhs.name
    && lhs.value == rhs.value
}
