//
//  ApiRecipe.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 21/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

internal struct RecipeItemMapper: Decodable {
    private struct Root: Decodable {
        let items: [RecipeItemMapper]
        
        var recipe: [Recipe] {
            return items.map { $0.item }
        }
        
        private enum CodingKeys: String, CodingKey {
            case items = "matches"
        }
    }
    
    let name: String
    let ingredients: [String]
    let id: String?
    let rate: Int
    let time: Int
    let imageURL: String
    var item: Recipe {
        return Recipe(name: name,
                      ingredients: ingredients,
                      id: id,
                      rate: rate,
                      time: time,
                      imageURL: imageURL,
                      details: nil)
    }
    
    private enum CodingKeys: String, CodingKey {
        case ingredients, id, imageUrlsBySize
        case name = "recipeName"
        case rate = "rating"
        case time = "totalTimeInSeconds"
    }
    
    private enum ImageURLCodingKeys: String, CodingKey {
        case imageURL = "90"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let imageURLContainer = try container.nestedContainer(keyedBy: ImageURLCodingKeys.self, forKey: .imageUrlsBySize)

        name = try container.decode(key: .name)
        ingredients = try container.decode(key: .ingredients)
        rate = try container.decode(key: .rate)
        time = try container.decode(key: .time)
        imageURL = try imageURLContainer.decode(key: .imageURL)

        id = try container.decodeIfPresent(key: .id)

    }

    static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) -> Result<[Recipe]> {
        guard response.statusCode == OK_200,
            let root = try? JSONDecoder().decode(Root.self, from: data) else {
                return .failure(ApiRecipesGatewayImplementation.Error.invalidData)
        }
        
        return .success(root.recipe)
    }
}
