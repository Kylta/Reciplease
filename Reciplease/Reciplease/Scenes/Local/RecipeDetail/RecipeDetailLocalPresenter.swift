//
//  RecipeDetailLocalPresenter.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 22/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

class RecipeDetailLocalPresenterImplementation: RecipeDetailPresenter {
    fileprivate let recipe: Recipe
    fileprivate var recipeDetails: RecipeDetail!
    fileprivate let displayRecipesUseCase: DisplayRecipesUseCase
    fileprivate let deleteRecipeUseCase: DeleteRecipeUseCase
    fileprivate weak var view: RecipeDetailView?
    private(set) var router: RecipeDetailLocalViewRouter

    var numberOfIngredients: Int {
        return recipe.ingredients.count
    }

    init(view: RecipeDetailView,
         addRecipeUseCase: AddRecipeUseCase,
         displayRecipesUseCase: DisplayRecipesUseCase,
         deleteRecipeUseCase: DeleteRecipeUseCase,
         router: RecipeDetailLocalViewRouter,
         recipe: Recipe) {
        self.view = view
        self.displayRecipesUseCase = displayRecipesUseCase
        self.deleteRecipeUseCase = deleteRecipeUseCase
        self.router = router
        self.recipe = recipe

        registerForDeleteRecipeNotification()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func viewDidLoad() {
        recipeDetails = recipe.details
        displayRecipesUseCase.displayRecipes { result in
            if case let .success(recipes) = result {
                self.view?.favorite(recipe: recipes.contains(self.recipe))
            }
        }

        view?.display(time: "\(recipeDetails.time / 60) m")
        view?.display(rating: recipeDetails.rate)
        view?.display(recipeName: recipeDetails.name)
        let recipeImageUrl = recipeDetails.imageURL.replacingOccurrences(of: "90-c", with: "300-c")
        view?.display(recipeImageUrl: recipeImageUrl)
    }

    func getDirectionsPressed() {
        let url = URL(string: recipeDetails.recipeURL)!
        view?.presentSafari(url: url)
    }

    func favoritesButtonPressed() {
        deleteRecipeUseCase.delete(recipe: recipe) { result in
            if case let .failure(error) = result {
                self.view?.displayRecipeDeleteError(title: "Error", message: error.localizedDescription)
            }
        }
    }

    func configure(cell: IngredientCellView, forRow row: Int) {
//        if recipeDetails?.ingredients {
//            cell.display(ingredient: recipeDetails.ingredients[row])
//        } else if recipeDetails?.nutritions {
//            cell.display(ingredient: recipeDetails.nutritions[row].name)
//        }
    }

    fileprivate func registerForDeleteRecipeNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveDeleteRecipeNotification),
                                               name: DeleteRecipeUseCaseNotifications.didDeleteRecipe,
                                               object: nil)
    }

    @objc fileprivate func didReceiveDeleteRecipeNotification(_ notification: Notification) {
        if let _ = notification.object as? Recipe {
            handleRecipeDeleted()
        }
    }

    fileprivate func handleRecipeDeleted() {
        router.dismiss()
    }
}

