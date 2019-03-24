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
    var nutritions: [Nutritions]
    var item: RecipeDetail {
        return RecipeDetail(name: name,
                            ingredients: ingredients,
                            rate: rate,
                            time: time,
                            imageURL: imageURL,
                            recipeURL: recipeURL,
                            nutritions: nutritions.map { $0.nutritions })
    }

    class Nutritions: Decodable {
        let value: Double
        let attribute: String
        let description: String?
        let unit: Unit
        var nutritions: RecipeNutritions {
            return RecipeNutritions(value: value,
                                    attribute: attribute,
                                    name: unit.name,
                                    abbreviation: unit.abbreviation,
                                    description: description ?? "")
        }

        class Unit: Decodable {
            let name: String
            let abbreviation: String
            let plural: String
            let pluralAbbreviation: String
        }
    }

    private enum CodingKeys: String, CodingKey {
        case images, name, attribution
        case ingredients = "ingredientLines"
        case rate = "rating"
        case time = "totalTimeInSeconds"
        case nutritions = "nutritionEstimates"
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

        nutritions = try container.decode([Nutritions].self, forKey: .nutritions)
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
