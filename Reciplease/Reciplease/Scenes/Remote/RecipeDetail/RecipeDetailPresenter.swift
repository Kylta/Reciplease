//
//  RecipeDetailPresenter.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 22/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

protocol RecipeDetailView: class {
    func display(recipeImageUrl: String)
    func display(recipeName: String)
    func display(rating: Int)
    func display(time: String)
    func favorite(recipe: Bool)
}

protocol RecipeDetailPresenter {
    var numberOfIngredients: Int { get }
    func viewDidLoad()
    func favoritesButtonPressed()
    func configure(cell: IngredientCellView, forRow row: Int)
}

class RecipeDetailPresenterImplementation: RecipeDetailPresenter {
    fileprivate let recipe: Recipe
    fileprivate var recipeDetail: RecipeDetail!
    fileprivate let addRecipeUseCase: AddRecipeUseCase
    fileprivate let displayRecipesUseCase: DisplayRecipesUseCase
    fileprivate weak var view: RecipeDetailView?

    var numberOfIngredients: Int {
        return recipeDetail.ingredients.count
    }

    init(view: RecipeDetailView,
         addRecipeUseCase: AddRecipeUseCase,
         displayRecipesUseCase: DisplayRecipesUseCase,
         recipe: Recipe) {
        self.view = view
        self.addRecipeUseCase = addRecipeUseCase
        self.displayRecipesUseCase = displayRecipesUseCase
        self.recipe = recipe
    }

    func viewDidLoad() {
        recipeDetail = recipe.details
        displayRecipesUseCase.displayRecipes { result in
            if case let .success(recipes) = result {
                self.view?.favorite(recipe: recipes.contains(self.recipe))
            }
        }

        view?.display(time: "\(recipeDetail.time / 60) min")
        view?.display(rating: recipeDetail.rate)
        view?.display(recipeName: recipeDetail.name)
        let recipeImageUrl = recipeDetail.imageURL.replacingOccurrences(of: "90-c", with: "300-c")
        view?.display(recipeImageUrl: recipeImageUrl)
    }

    func favoritesButtonPressed() {
        let recipeParameters = AddRecipeParameters(name: recipe.name, ingredients: recipe.ingredients, id: recipe.id, rate: recipe.rate, time: recipe.time, imageURL: recipe.imageURL)
        let recipeDetailParameters = AddRecipeDetailParameters(name: recipeDetail.name, ingredients: recipeDetail.ingredients, rate: recipeDetail.rate, time: recipeDetail.time, imageURL: recipeDetail.imageURL)
        addRecipeUseCase.add(parameters: recipeParameters, detailsParameters: recipeDetailParameters) { result in
            switch result {
            case .success:
                self.view?.favorite(recipe: true)
            case .failure:
                self.view?.favorite(recipe: false)
            }
        }
    }

    func configure(cell: IngredientCellView, forRow row: Int) {
        cell.display(ingredient: recipeDetail.ingredients[row])
    }
}

