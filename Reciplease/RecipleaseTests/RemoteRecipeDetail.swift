//
//  RemoteRecipeListDetail.swift
//  RecipleaseTests
//
//  Created by Christophe Bugnon on 24/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import XCTest
@testable import Reciplease

class RemoteRecipeDetailTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestDataFromURL() {
        let url = URL(string: "another-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.fetchRecipes { _ in }

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestDataFromURLTwice() {
        let url = URL(string: "another-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.fetchRecipes { _ in }
        sut.fetchRecipes { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData), when: {
                client.complete(withStatusCode: code, data: makeJSON(), at: index)
            })
        }
    }

    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: failure(.invalidData), when: {
            let invalidJSON = Data(bytes: "invalidJSON".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }

    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()

        let item = makeItem(name: "Meatball Parmesan Casserole", ingredients: ["1 cup shredded parmesan cheese"],rate: 4, time: 60, imageURL: "https:lh3.googleusercontent.com", recipeURL: "http:www.yummly.co/recipe/Meatball-Parmesan-Casserole-2626493", value: 80.00, attribute: "FAT_KCAL", nameNutrition: "calorie", abbreviation: "kcal", description: "description")

        expect(sut, toCompleteWith: .success(item), when: {
            client.complete(withStatusCode: 200, data: recipeDetailData)
        })
    }

    fileprivate func makeSUT(url: URL = URL(string: "any-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: ApiRecipesGatewayImplementation, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = ApiRecipesGatewayImplementation(url: url, client: client)
        return (sut, client)
    }

    fileprivate func failure(_ error: ApiRecipesGatewayImplementation.Error) -> Result<RecipeDetail> {
        return .failure(error)
    }

    fileprivate func makeItem(name: String, ingredients: [String], rate: Int, time: Int, imageURL: String, recipeURL: String, value: Double, attribute: String, nameNutrition: String, abbreviation: String, description: String?) -> RecipeDetail {
        let nutrition = RecipeNutritions(value: value, attribute: attribute, name: nameNutrition, abbreviation: abbreviation, description: description)
        let item = RecipeDetail(name: name, ingredients: ingredients, rate: rate, time: time, imageURL: imageURL, recipeURL: recipeURL, nutritions: [nutrition])
        return item
    }

    fileprivate func makeJSON() -> Data {
        let filePath = Bundle(for: type(of: self)).url(forResource: "recipeDetail", withExtension: "json")!
        return try! Data(contentsOf: filePath)
    }

    fileprivate func expect(_ sut: ApiRecipesGatewayImplementation, toCompleteWith expectedResult: Result<RecipeDetail>, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for completion")

        sut.fetchRecipesDetail { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)

            case let (.failure(receivedError as ApiRecipesGatewayImplementation.Error), .failure(expectedError as ApiRecipesGatewayImplementation.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)

            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()

        wait(for: [exp], timeout: 1.0)
    }

    fileprivate class HTTPClientSpy: ApiClient {
        var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }

        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }

        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }

        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }
}

var recipeDetailData = Data(bytes: """
{"yield":"Serves 6-8","nutritionEstimates":[{"attribute":"FAT_KCAL","description":"description","value":80.00,"unit":{"id":"fea252f8-9888-4365-b005-e2c63ed3a776","name":"calorie","abbreviation":"kcal","plural":"calories","pluralAbbreviation":"kcal","decimal":true}}],"totalTime":"15 min","images":[{"hostedSmallUrl":"https:lh3.googleusercontent.com/3dbNmfS4BI-7CUsm2WYE8l7-90CNi3rQPUkO5EMc0gts_MBUAVZlTngm-9VHshp9toXl73RKwiUs9JQCpx6RoQ=s90","hostedMediumUrl":"https/lh3.googleusercontent.com/3dbNmfS4BI-7CUsm2WYE8l7-90CNi3rQPUkO5EMc0gts_MBUAVZlTngm-9VHshp9toXl73RKwiUs9JQCpx6RoQ=s180","hostedLargeUrl":"https:lh3.googleusercontent.com","imageUrlsBySize":{"90":"https:lh3.googleusercontent.com/8H_kR4fF6IE517FKDHGOyVHEgNmmCdhX_Yz2YfxIDJgCQoU_NJ-hw_FJ1jEolQPPAfoKuKMw4jYjJK512gTyfQ=s90-c","360":"https:lh3.googleusercontent.com/8H_kR4fF6IE517FKDHGOyVHEgNmmCdhX_Yz2YfxIDJgCQoU_NJ-hw_FJ1jEolQPPAfoKuKMw4jYjJK512gTyfQ=s360-c"}}],"name":"Meatball Parmesan Casserole","source":{"sourceDisplayName":"Mrs. Happy Homemaker","sourceSiteUrl":"mrshappyhomemaker.com","sourceRecipeUrl":"https:www.mrshappyhomemaker.com/meatball-parmesan-casserole/"},"id":"Meatball-Parmesan-Casserole-2626493","ingredientLines":["1 cup shredded parmesan cheese"],"cookTime":"15 Min","attribution":{"html":"<a href='http:www.yummly.co/recipe/Meatball-Parmesan-Casserole-2626493'>Meatball Parmesan Casserole recipe</a> information powered by <img alt='Yummly' src='https:static.yummly.co/api-logo.png'/>","url":"http:www.yummly.co/recipe/Meatball-Parmesan-Casserole-2626493","text":"Meatball Parmesan Casserole recipes: information powered by Yummly","logo":"https/static.yummly.co/api-logo.png"},"numberOfServings":7,"totalTimeInSeconds":60,"attributes":{"course":["Main Dishes"]},"cookTimeInSeconds":900,"flavors":{},"rating":4}
""".utf8)
