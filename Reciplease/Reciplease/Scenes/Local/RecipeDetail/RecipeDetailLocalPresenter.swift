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
    fileprivate var recipeNutritions = [RecipeNutritions]()

    var numberOfRows: (ingredients: Int, total: Int) {
        return (recipeDetails.ingredients.count, recipeDetails.ingredients.count + recipeNutritions.count)
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

        recipeNutritions = recipeDetails.nutritions.filter {
            $0.attribute == "K"
                || $0.attribute == "NA"
                || $0.attribute == "CHOLE"
                || $0.attribute == "FIBTG"
                || $0.attribute == "FATRN"
                || $0.attribute == "PROCNT"
                || $0.attribute == "VITC"
                || $0.attribute == "CA"
                || $0.attribute == "SUGAR"
                || $0.attribute == "ENERC_KCAL"
                || $0.attribute == "FAT"
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
        cell.display(ingredient: recipeDetails.ingredients[row])
    }

    func configure(cell: NutritionCellView, forRow row: Int) {
        let nutritionsRow = row - recipeDetails.ingredients.count
        let nutritions = recipeNutritions[nutritionsRow]

        cell.display(name: nutritions.attribute)
        cell.display(description: nutritions.description ?? "")
        cell.display(value: String(nutritions.value))
        cell.display(abbreviation: nutritions.abbreviation)
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

