//
//  ApiRecipeDetail.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 23/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

internal struct RecipeDetailItemMapper: Decodable {
    let name: String
    let ingredients: [String]
    let rate: Int
    let time: Int
    let imageURL: String
    let recipeURL: String
    var item: RecipeDetail {
        return RecipeDetail(name: name, ingredients: ingredients, rate: rate, time: time, imageURL: imageURL, recipeURL: recipeURL)
    }

    private enum CodingKeys: String, CodingKey {
        case images, name, attribution
        case ingredients = "ingredientLines"
        case rate = "rating"
        case time = "totalTimeInSeconds"
    }

    private enum ImageCodingKeys: String, CodingKey {
        case imageUrlsBySize
    }

    private enum URLCodingKeys: String, CodingKey {
        case url
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var imageURLContainer = try container.nestedUnkeyedContainer(forKey: .images)
        let attributionContainer = try container.nestedContainer(keyedBy: URLCodingKeys.self, forKey: .attribution)

        name = try container.decode(key: .name)
        ingredients = try container.decode(key: .ingredients)
        rate = try container.decode(key: .rate)
        time = try container.decode(key: .time)
        recipeURL = try attributionContainer.decode(key: .url)

        let imageURL = try imageURLContainer.decode([String: Any].self)
        self.imageURL = imageURL["hostedLargeUrl"] as! String
    }

    static var OK_200: Int { return 200 }

    static func map(_ data: Data, _ response: HTTPURLResponse) -> Result<RecipeDetail> {
        guard response.statusCode == OK_200,
            let recipeDetail = try? JSONDecoder().decode(RecipeDetailItemMapper.self, from: data) else {
                return .failure(ApiRecipesGatewayImplementation.Error.invalidData)
        }

        return .success(recipeDetail.item)
    }
}
