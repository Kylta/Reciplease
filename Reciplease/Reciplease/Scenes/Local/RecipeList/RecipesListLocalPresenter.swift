//
//  RecipesListLocalPresenter.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 22/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

protocol RecipeListLocalPresenter {
    func presentAlert(title: String, message: String)
}

class RecipesListLocalPresenterImplementation: RecipesListPresenter, RecipeListLocalPresenter {
    fileprivate weak var view: RecipesListView?
    fileprivate var displayRecipesUseCase: DisplayRecipesUseCase
    private(set) var router: RecipesListViewRouter

    private var recipes = [Recipe]()

    init(view: RecipesListView,
         displayRecipesUseCase: DisplayRecipesUseCase,
         router: RecipesListViewRouter) {
        self.view = view
        self.displayRecipesUseCase = displayRecipesUseCase
        self.router = router
    }

    var numbersOfRecipes: Int {
        return recipes.count
    }

    func viewDidLoad() {
        displayRecipesUseCase.displayRecipes { result in
            switch result {
            case let .success(recipes):
                self.checkRecipesNoneEmpty(recipes: recipes)
            case let .failure(error):
                print(error)
            }
        }
    }

    func presentAlert(title: String, message: String) {
        view?.displayRecipesRetrievalError(title: title, message: message)
    }

    func didSelect(row: Int) {
        let recipe = recipes[row]
        self.router.presentRecipeDetailView(for: recipe)
    }

    func configure(cell: RecipesListCellView, forRow row: Int) {
        let recipe = recipes[row]
        let recipeImageUrl = recipe.imageURL.replacingOccurrences(of: "90-c", with: "300-c")
        cell.display(recipeName: recipe.name)
        cell.display(recipesIngredients: recipe.ingredients.joined(separator: ", "))
        cell.display(time: "\(recipe.time / 60) m")
        cell.display(rating: recipe.rate)
        cell.display(recipeImageUrl: recipeImageUrl)
    }

    fileprivate func checkRecipesNoneEmpty(recipes: [Recipe]) {
        if recipes.isEmpty {
            refreshViewWith(recipes)
            view?.displayRecipesRetrievalError(title: "You have no favorites", message: "Go search recipe and at them to your favorites")
        } else {
            refreshViewWith(recipes)
        }
    }

    fileprivate func refreshViewWith(_ recipes: [Recipe]) {
        self.recipes = recipes
        self.view?.refreshView()
    }

    func cancelButtonPressed() {}
}
