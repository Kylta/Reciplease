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
    fileprivate let displayRecipesUseCase: DisplayRecipesUseCase
    fileprivate weak var view: RecipeDetailView?

    var numberOfIngredients: Int {
        return recipe.ingredients.count
    }

    init(view: RecipeDetailView,
         addRecipeUseCase: AddRecipeUseCase,
         displayRecipesUseCase: DisplayRecipesUseCase,
         recipe: Recipe) {
        self.view = view
        self.displayRecipesUseCase = displayRecipesUseCase
        self.recipe = recipe
    }

    func viewDidLoad() {
        displayRecipesUseCase.displayRecipes { result in
            if case let .success(recipes) = result {
                self.view?.favorite(recipe: recipes.contains(self.recipe))
            }
        }

        view?.display(time: "\(recipe.time / 60) m")
        view?.display(rating: recipe.rate)
        view?.display(recipeName: recipe.name)
        let recipeImageUrl = recipe.imageURL.replacingOccurrences(of: "90-c", with: "300-c")
        view?.display(recipeImageUrl: recipeImageUrl)
    }

    func addButtonPressed() {
//        let parameters = AddRecipeParameters(name: recipe.name, ingredients: recipe.ingredients, id: recipe.id, rate: recipe.rate, time: recipe.time, imageURL: recipe.imageURL)
//        addRecipeUseCase.add(parameters: parameters) { result in
//            switch result {
//            case .success:
//                self.view?.favorite(recipe: true)
//            case .failure:
//                self.view?.favorite(recipe: false)
//            }
//        }
    }

    func configure(cell: IngredientCellView, forRow row: Int) {
        cell.display(ingredient: recipe.ingredients[row])
    }
}

