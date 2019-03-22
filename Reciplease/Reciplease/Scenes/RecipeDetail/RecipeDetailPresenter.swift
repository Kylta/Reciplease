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
}

protocol RecipeDetailPresenter {
    var numberOfIngredients: Int { get }
    func viewDidLoad()
    func configure(cell: IngredientCellView, forRow row: Int)
}

class RecipeDetailPresenterImplementation: RecipeDetailPresenter {
    fileprivate let recipe: Recipe
    fileprivate weak var view: RecipeDetailView?

    var numberOfIngredients: Int {
        return recipe.ingredients.count
    }

    init(view: RecipeDetailView, recipe: Recipe) {
        self.view = view
        self.recipe = recipe
    }

    func viewDidLoad() {
        view?.display(time: "\(recipe.time / 60) m")
        view?.display(rating: recipe.rate)
        view?.display(recipeName: recipe.name)
        let recipeImageUrl = recipe.imageURL.replacingOccurrences(of: "90-c", with: "300-c")
        view?.display(recipeImageUrl: recipeImageUrl)
    }

    func configure(cell: IngredientCellView, forRow row: Int) {
        cell.display(ingredient: recipe.ingredients[row])
    }
}

