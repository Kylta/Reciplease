//
//  ApiRecipesGateway.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 21/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

protocol ApiRecipesGateway: RecipesGateway {}

final class ApiRecipesGatewayImplementation: ApiRecipesGateway {
    private let client: ApiClient

    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    init(client: ApiClient) {
        self.client = client
    }

    func fetchRecipes(completionHandler: @escaping FetchRecipesEntityGatewayCompletionHandler) {
        let url = URL(string: "https://api.yummly.com/v1/api/recipes?_app_id=82f4a536&_app_key=51bc109f3d02f621f3e62397cd754d62&q=POTATOES&requirePictures=true")!
        client.get(from: url) { result in

            switch result {
            case let .success(data, response):
                let result = RecipeItemMapper.map(data, response)
                guard let recipes = try? result.dematerialize() else { return
                    completionHandler(.failure(ApiRecipesGatewayImplementation.Error.invalidData))
                }
                completionHandler(.success(recipes))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }

    func add(parameters: AddRecipeParameters, completionHandler: @escaping AddRecipeEntityGatewayCompletionHandler) { }

    func delete(recipe: Recipe, completionHandler: @escaping DeleteRecipeEntityGatewayCompletionHandler) { }
}
