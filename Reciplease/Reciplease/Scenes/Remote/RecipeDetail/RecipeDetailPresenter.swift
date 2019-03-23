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
    fileprivate let recipeDetail: RecipeDetail
    fileprivate let addRecipeUseCase: AddRecipeUseCase
    fileprivate let displayRecipesUseCase: DisplayRecipesUseCase
    fileprivate weak var view: RecipeDetailView?

    var numberOfIngredients: Int {
        return recipeDetail.ingredients.count
    }

    init(view: RecipeDetailView,
         addRecipeUseCase: AddRecipeUseCase,
         displayRecipesUseCase: DisplayRecipesUseCase,
         recipeDetail: RecipeDetail) {
        self.view = view
        self.addRecipeUseCase = addRecipeUseCase
        self.displayRecipesUseCase = displayRecipesUseCase
        self.recipeDetail = recipeDetail
    }

    func viewDidLoad() {
//        displayRecipesUseCase.displayRecipes { result in
//            if case let .success(recipes) = result {
//                self.view?.favorite(recipe: recipes.contains(self.recipeDetail))
//            }
//        }

        view?.display(time: "\(recipeDetail.time / 60) min")
        view?.display(rating: recipeDetail.rate)
        view?.display(recipeName: recipeDetail.name)
        let recipeImageUrl = recipeDetail.imageURL.replacingOccurrences(of: "90-c", with: "300-c")
        view?.display(recipeImageUrl: recipeImageUrl)
    }

    func favoritesButtonPressed() {
//        let parameters = AddRecipeParameters(name: recipeDetail.name, ingredients: recipeDetail.ingredients, id: recipe.id, rate: recipe.rate, time: recipe.time, imageURL: recipe.imageURL, detail: recipe.detail)
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
        cell.display(ingredient: recipeDetail.ingredients[row])
    }
}

