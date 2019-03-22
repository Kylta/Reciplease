//
//  RecipesListPresenter.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 22/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

protocol RecipesListView: class {
    func refreshView()
    func displayRecipesRetrievalError(title: String, message: String)
}

protocol RecipesListPresenterDelegate: class {
    func recipesListPresenterCancel(presenter: RecipesListPresenter)
}

protocol RecipesListCellView {
    func display(recipeImageUrl: String)
    func display(recipeName: String)
    func display(recipesIngredients: String)
    func display(rating: Int)
    func display(time: String)
}

protocol RecipesListPresenter {
    var numbersOfRecipes: Int { get }
    var router: RecipesListViewRouter { get }
    func viewDidLoad()
    func configure(cell: RecipesListCellView, forRow row: Int)
    func cancelButtonPressed()
}

class RecipesListPresenterImplementation: RecipesListPresenter {
    fileprivate weak var view: RecipesListView?
    fileprivate weak var delegate: RecipesListPresenterDelegate?
    private(set) var router: RecipesListViewRouter

    var recipes: [Recipe]

    init(view: RecipesListView,
         recipes: [Recipe],
         delegate: RecipesListPresenterDelegate?,
         router: RecipesListViewRouter) {
        self.view = view
        self.router = router
        self.delegate = delegate
        self.recipes = recipes
    }

    var numbersOfRecipes: Int {
        return recipes.count
    }

    func viewDidLoad() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.view?.refreshView()
        }
    }

    func cancelButtonPressed() {
        delegate?.recipesListPresenterCancel(presenter: self)
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
}
