//
//  LocalPersistenceRecipeGateway.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 21/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation
import CoreData

protocol LocalPersistenceRecipesGateway: RecipesGateway {}

class CoreDataRecipesGateway: LocalPersistenceRecipesGateway {
    let viewContext: NSManagedObjectContextProtocol

    init(viewContext: NSManagedObjectContextProtocol) {
        self.viewContext = viewContext
    }

    // MARK: - RecipesGateway

    func fetchRecipes(completionHandler: @escaping FetchRecipesEntityGatewayCompletionHandler) {
        if let coreDataRecipes = try? viewContext.allEntities(withType: CoreDataRecipe.self) {
            let recipes = coreDataRecipes.map { $0.recipe }
            completionHandler(.success(recipes))
        } else {
            completionHandler(.failure(CoreError(message: "Failed retrieving recipes the data base")))
        }
    }

    func add(parameters: AddRecipeParameters, completionHandler: @escaping AddRecipeEntityGatewayCompletionHandler) {
        guard let coreDataRecipe = viewContext.addEntity(withType: CoreDataRecipe.self) else {
            completionHandler(.failure(CoreError(message: "Failed adding the recipe in the data base")))
            return
        }

        coreDataRecipe.populate(with: parameters)

        do {
            try viewContext.save()
            completionHandler(.success(coreDataRecipe.recipe))
        } catch {
            viewContext.delete(coreDataRecipe)
            completionHandler(.failure(CoreError(message: "Failed saving the context")))
        }
    }

    func delete(recipe: Recipe, completionHandler: @escaping DeleteRecipeEntityGatewayCompletionHandler) {
        let predicate = NSPredicate(format: "name==%@", recipe.name)

        if let coreDataRecipes = try? viewContext.allEntities(withType: CoreDataRecipe.self, predicate: predicate),
            let coreDataRecipe = coreDataRecipes.first {
            viewContext.delete(coreDataRecipe)
        } else {
            completionHandler(.failure(CoreError(message: "Failed retrieving recipes the data base")))
        }

        do {
            try viewContext.save()
            completionHandler(.success(()))
        } catch {
            completionHandler(.failure(CoreError(message: "Failed saving the context")))
        }
    }
}
