//
//  RecipesListLocalPresenter.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 22/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

class RecipesListLocalPresenterImplementation: RecipesListPresenter {
    weak var view: RecipesListView?
    var displayRecipesUseCase: DisplayRecipesUseCase
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
                self.recipes = recipes
                self.view?.refreshView()
            case let .failure(error):
                print(error)
            }
        }
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

    func cancelButtonPressed() {}
}
