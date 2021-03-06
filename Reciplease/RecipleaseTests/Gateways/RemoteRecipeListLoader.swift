//
//  RemoteRecipeListLoader.swift
//  RecipleaseTests
//
//  Created by Christophe Bugnon on 24/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import XCTest
@testable import Reciplease

class RemoteRecipeLoaderTests: XCTestCase {

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

    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .success([]), when: {
            let emptyListJSON = Data(bytes: "{\"matches\": []}".utf8)
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }

    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()

        let item1 = makeItem(name: "a name", ingredients: ["any ingredients"], id: "an id", rate: 4, time: 60, imageURL: "image-url.com")
        let item2 = makeItem(name: "another name", ingredients: ["another ingredients"], id: nil, rate: 1, time: 600, imageURL: "another-image-url.com")

        expect(sut, toCompleteWith: .success([item1, item2]), when: {
            client.complete(withStatusCode: 200, data: makeJSON())
        })
    }

    fileprivate func makeSUT(url: URL = URL(string: "any-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: ApiRecipesGatewayImplementation, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = ApiRecipesGatewayImplementation(url: url, client: client)
        return (sut, client)
    }

    fileprivate func failure(_ error: ApiRecipesGatewayImplementation.Error) -> Result<[Recipe]> {
        return .failure(error)
    }

    fileprivate func makeItem(name: String, ingredients: [String], id: String? = nil, rate: Int, time: Int, imageURL: String) -> Recipe {
        let item = Recipe(name: name, ingredients: ingredients, id: id, rate: rate, time: time, imageURL: imageURL, details: nil)

        return item
    }

    fileprivate func makeJSON() -> Data {
        let filePath = Bundle(for: type(of: self)).url(forResource: "recipe", withExtension: "json")!
        return try! Data(contentsOf: filePath)
    }

    fileprivate func expect(_ sut: ApiRecipesGatewayImplementation, toCompleteWith expectedResult: Result<[Recipe]>, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for completion")

        sut.fetchRecipes { receivedResult in
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

