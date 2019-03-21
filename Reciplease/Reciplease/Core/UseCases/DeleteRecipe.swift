//
//  DeleteRecipe.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 21/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

typealias DeleteRecipeUseCaseCompletionHanlder = (_ recipe: Result<Void>) -> Void

struct DeleteRecipeUseCaseNotifications {
    static let didDeleteRecipe = Notification.Name("didDeleteRecipeNotification")
}

protocol DeleteRecipeUseCase {
    func delete(recipe: Recipe, completionHandler: @escaping DeleteRecipeUseCaseCompletionHanlder)
}

class DeleteRecipeUseCaseImplementation: DeleteRecipeUseCase {
    let recipeGateway: RecipesGateway

    init(recipeGateway: RecipesGateway) {
        self.recipeGateway = recipeGateway
    }

    // MARK: - DeleteRecipeUseCase
    
    func delete(recipe: Recipe, completionHandler: @escaping DeleteRecipeUseCaseCompletionHanlder) {
        self.recipeGateway.delete(recipe: recipe) { result in
            switch result {
            case .success:
                NotificationCenter.default.post(name: DeleteRecipeUseCaseNotifications.didDeleteRecipe, object: recipe)
                completionHandler(result)
            case .failure:
                completionHandler(result)
            }
        }
    }
}
