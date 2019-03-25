//
//  CoreDataRecipeGatewayTest.swift
//  RecipleaseTests
//
//  Created by Christophe Bugnon on 25/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

import XCTest
@testable import Reciplease

class CoreDataRecipesGatewayTest: XCTestCase {
    var inMemoryCoreDataStack = InMemoryCoreDataStack()
    var managedObjectContextSpy = NSManagedObjectContextSpy()

    var inMemoryCoreDataRecipesGateway: CoreDataRecipesGateway {
        return CoreDataRecipesGateway(viewContext: inMemoryCoreDataStack.persistentContainer.viewContext)
    }

    var errorPathCoreDataRecipesGateway: CoreDataRecipesGateway {
        return CoreDataRecipesGateway(viewContext: managedObjectContextSpy)
    }

    func test_add_with_parameters_fetchRecipes_withParameters_success() {
        // Given
        let addRecipeParameters = AddRecipeParameters.createParameters()
        let addRecipeDetailParameters = AddRecipeDetailParameters.createParameters()
        let addRecipeNutritionParameters = AddRecipeNutritionsParameters.createParameters()

        var addRecipeCompletionHandlerExpectation: XCTestExpectation? = expectation(description: "Add recipe completion handler expectation")
        var fetchRecipesCompletionHandlerExpectation: XCTestExpectation? = expectation(description: "Fetch Recipes completion handler expectation")

        // When
        inMemoryCoreDataRecipesGateway.add(parameters: addRecipeParameters, detailsParameters: addRecipeDetailParameters, nutritrionsParameters: [addRecipeNutritionParameters]) { (result) in
            // Then
            guard let recipe = try? result.dematerialize() else {
                XCTFail("Should've saved the recipe with success")
                return
            }

            Assert(recipe: recipe, builtFromParameters: addRecipeParameters)
            Assert(recipe: recipe, wasAddedIn: self.inMemoryCoreDataRecipesGateway, expectation: fetchRecipesCompletionHandlerExpectation!)

            addRecipeCompletionHandlerExpectation?.fulfill()
            addRecipeCompletionHandlerExpectation = nil
            fetchRecipesCompletionHandlerExpectation = nil
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func test_fetch_failure() {
        // Given
        let expectedResultToBeReturned: Result<[Recipe]> = .failure(CoreError(message: "Failed retrieving recipes the data base"))
        managedObjectContextSpy.fetchErrorToThrow = NSError.createError(withMessage: "Some core data error")

        let fetchRecipesCompletionHandlerExpectation = expectation(description: "Fetch Recipes completion handler expectation")

        // When
        errorPathCoreDataRecipesGateway.fetchRecipes { (result) in
            // Then
            switch (expectedResultToBeReturned, result) {
            case (let .failure(expectedError), let .failure(receivedError)):
                XCTAssertEqual(expectedError.localizedDescription, receivedError.localizedDescription)
            default: XCTFail("Expected to received error but got \(result) instead")
            }

            fetchRecipesCompletionHandlerExpectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func test_deleteRecipe_success() {
        // Given
        let addRecipeParameters1 = AddRecipeParameters.createParameters()
        var addedRecipe1: Recipe!
        let addRecipe1CompletionHandlerExpectation = expectation(description: "Add recipe completion handler expectation")
        inMemoryCoreDataRecipesGateway.add(parameters: addRecipeParameters1, detailsParameters: AddRecipeDetailParameters.createParameters(), nutritrionsParameters: [AddRecipeNutritionsParameters.createParameters()]) { (result) in
            addedRecipe1 = try! result.dematerialize()
            addRecipe1CompletionHandlerExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)

        let addRecipeParameters2 = AddRecipeParameters.createParameters2()
        var addedRecipe2: Recipe!
        let addRecipe2CompletionHandlerExpectation = expectation(description: "Add recipe completion handler expectation")

        inMemoryCoreDataRecipesGateway.add(parameters: addRecipeParameters2,
                                           detailsParameters: AddRecipeDetailParameters.createParameters2(),
                                           nutritrionsParameters: [AddRecipeNutritionsParameters.createParameters2()]) { (result) in
            addedRecipe2 = try! result.dematerialize()
            addRecipe2CompletionHandlerExpectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)

        let deleteRecipeCompletionHandlerExpectation = expectation(description: "Delete recipe completion handler expectation")

        // When
        inMemoryCoreDataRecipesGateway.delete(recipe: addedRecipe1) { (result) in
            XCTAssertEqual(result, Result<Void>.success(()), "Expected a success result")
            deleteRecipeCompletionHandlerExpectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)

        // Then
        let fetchRecipesCompletionHandlerExpectation = expectation(description: "Fetch Recipes completion handler expectation")
        inMemoryCoreDataRecipesGateway.fetchRecipes { (result) in
            let Recipes = try! result.dematerialize()
            XCTAssertFalse(Recipes.contains(addedRecipe1), "The added recipe should've been deleted")
            XCTAssertTrue(Recipes.contains(addedRecipe2), "The second recipe should be contained")
            fetchRecipesCompletionHandlerExpectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func test_delete_fetch_fails() {
        let recipeToDelete = Recipe.createRecipe()
        let expectedResultToBeReturned: Result<Void> = .failure(CoreError(message: "Failed retrieving recipes the data base"))
        managedObjectContextSpy.fetchErrorToThrow = NSError.createError(withMessage: "Some core data error")

        var deleteRecipeCompletionHandlerExpectation: XCTestExpectation? = expectation(description: "Delete recipe completion handler expectation")

        // When
        errorPathCoreDataRecipesGateway.delete(recipe: recipeToDelete) { (result) in
            // Then
            XCTAssertEqual(expectedResultToBeReturned, result, "Failure error wasn't returned")
            deleteRecipeCompletionHandlerExpectation?.fulfill()
            deleteRecipeCompletionHandlerExpectation = nil
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func test_delete_save_fails() {
        let recipeToDelete = Recipe.createRecipe()
        let expectedResultToBeReturned: Result<Void> = .failure(CoreError(message: "Failed saving the context"))
        managedObjectContextSpy.entitiesToReturn = [inMemoryCoreDataStack.fakeEntity(withType: CoreDataRecipe.self)]
        managedObjectContextSpy.saveErrorToReturn = NSError.createError(withMessage: "Some core data error")

        let deleteRecipeCompletionHandlerExpectation = expectation(description: "Delete recipe completion handler expectation")

        // When
        errorPathCoreDataRecipesGateway.delete(recipe: recipeToDelete) { (result) in
            // Then
            XCTAssertEqual(expectedResultToBeReturned, result, "Failure error wasn't returned")
            deleteRecipeCompletionHandlerExpectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
}

// MARK: - Helpers

fileprivate func Assert(recipe: Recipe, builtFromParameters parameters: AddRecipeParameters, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(recipe.id, parameters.id, "id mismatch", file: file, line: line)
    XCTAssertEqual(recipe.imageURL, parameters.imageURL, "imageUrl mismatch", file: file, line: line)
    XCTAssertEqual(recipe.ingredients, parameters.ingredients, "ingredients mismatch", file: file, line: line)
    XCTAssertEqual(recipe.name, parameters.name, "name mismatch", file: file, line: line)
    XCTAssertEqual(recipe.rate, parameters.rate, "rate mismatch", file: file, line: line)
    XCTAssertEqual(recipe.time, parameters.time, "time mismatch", file: file, line: line)
}

fileprivate func Assert(recipe: Recipe, wasAddedIn coreDataRecipesGateway: CoreDataRecipesGateway, expectation: XCTestExpectation) {
    coreDataRecipesGateway.fetchRecipes { (result) in
        guard let Recipes = try? result.dematerialize() else {
            XCTFail("Should've fetched the Recipes with success")
            return
        }

        XCTAssertTrue(Recipes.contains(recipe), "recipe is not found in the returned Recipes")
        XCTAssertEqual(Recipes.count, 1, "Recipes array should contain exactly one recipe")
        expectation.fulfill()
    }
}
