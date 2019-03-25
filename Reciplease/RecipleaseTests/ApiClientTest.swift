//
//  ApiClientTest.swift
//  RecipleaseTests
//
//  Created by Christophe Bugnon on 25/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import XCTest
@testable import Reciplease

//class ApiClientTest: XCTestCase {
//    func test_apiClient_giveRecipeOnGetRequest() {
//        let apiClient = ApiClientImplementation()
//        let url = URL(string: "https://api.yummly.com/v1/api/recipes?_app_id=82f4a536&_app_key=51bc109f3d02f621f3e62397cd754d62&q=POTATOES&requirePictures=true")!
//        let apiGateway = ApiRecipesGatewayImplementation(url: url, client: apiClient)
//
//        apiGateway.fetchRecipes { response in
//            switch response {
//            case let .success(recipe):
//                XCTAssertNotNil(recipe)
//            case let .failure(error):
//                XCTFail("Expected result but got \(error) instead")
//            }
//        }
//    }
//}
