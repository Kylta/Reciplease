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
    func presentSafari(url: URL)
    func displayRecipeDeleteError(title: String, message: String)
}

protocol RecipeDetailPresenter {
    var numberOfRows: (ingredients: Int, total: Int) { get }
    func viewDidLoad()
    func favoritesButtonPressed()
    func getDirectionsPressed()
    func configure(cell: IngredientCellView, forRow row: Int)
    func configure(cell: NutritionCellView, forRow row: Int)
}

class RecipeDetailPresenterImplementation: RecipeDetailPresenter {
    fileprivate let recipe: Recipe
    fileprivate var recipeDetail: RecipeDetail!
    fileprivate let addRecipeUseCase: AddRecipeUseCase
    fileprivate let displayRecipesUseCase: DisplayRecipesUseCase
    fileprivate weak var view: RecipeDetailView?
    var recipeNutritions = [RecipeNutritions]()

    var numberOfRows: (ingredients: Int, total: Int) {
        return (recipeDetail.ingredients.count, recipeDetail.ingredients.count + recipeNutritions.count)
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
                self.view?.favorite(recipe: (recipes.first(where: {$0.name == self.recipe.name }) != nil))
            }
        }

        recipeNutritions = recipeDetail.nutritions.filter {
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

        view?.display(time: "\(recipeDetail.time / 60) min")
        view?.display(rating: recipeDetail.rate)
        view?.display(recipeName: recipeDetail.name)
        let recipeImageUrl = recipeDetail.imageURL.replacingOccurrences(of: "90-c", with: "300-c")
        view?.display(recipeImageUrl: recipeImageUrl)
    }

    func getDirectionsPressed() {
        let url = URL(string: recipeDetail.recipeURL)!
        view?.presentSafari(url: url)
    }


    func favoritesButtonPressed() {
        let recipeParameters = AddRecipeParameters(name: recipe.name, ingredients: recipe.ingredients, id: recipe.id, rate: recipe.rate, time: recipe.time, imageURL: recipe.imageURL)
        let recipeDetailParameters = AddRecipeDetailParameters(name: recipeDetail.name, ingredients: recipeDetail.ingredients, rate: recipeDetail.rate, time: recipeDetail.time, imageURL: recipeDetail.imageURL, recipeURL: recipeDetail.recipeURL)
        let recipeNutritionsParameters = recipe.details?.nutritions.map { AddRecipeNutritionsParameters(value: $0.value, name: $0.name, abbreviation: $0.abbreviation, description: $0.description, attribute: $0.attribute) }
        
        addRecipeUseCase.add(parameters: recipeParameters, detailsParameters: recipeDetailParameters, nutritrionsParameters: recipeNutritionsParameters!) { result in
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

    func configure(cell: NutritionCellView, forRow row: Int) {
        let nutritionsRow = row - recipeDetail.ingredients.count
        let nutritions = recipeNutritions[nutritionsRow]

        cell.display(name: nutritions.attribute)
        cell.display(description: nutritions.description ?? "")
        cell.display(value: String(nutritions.value))
        cell.display(abbreviation: nutritions.abbreviation)
    }
}

