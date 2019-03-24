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
    func showLoader()
    func hideLoader()
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
    func didSelect(row: Int)
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
        self.view?.refreshView()
    }
    
    func cancelButtonPressed() {
        delegate?.recipesListPresenterCancel(presenter: self)
    }
    
    func didSelect(row: Int) {
        view?.showLoader()
        var recipe = recipes[row]
        let client = ApiClientImplementation()
        let url = URL(string: "https://api.yummly.com/v1/api/recipe/\(recipe.id ?? "")?_app_id=82f4a536&_app_key=51bc109f3d02f621f3e62397cd754d62")!
        let request = ApiRecipesGatewayImplementation(url: url, client: client)
        request.fetchRecipesDetail { [weak self] result in
            switch result {
            case let .success(recipeDetail):
                recipe.details = recipeDetail
                self?.router.presentRecipeDetailView(for: recipe)
            case let .failure(error):
                self?.view?.displayRecipesRetrievalError(title: "Error", message: error.localizedDescription)
            }
            self?.view?.hideLoader()
        }
    }
    
    func configure(cell: RecipesListCellView, forRow row: Int) {
        let recipe = recipes[row]
        let recipeImageUrl = recipe.imageURL.replacingOccurrences(of: "90-c", with: "500-c")
        cell.display(recipeName: recipe.name)
        cell.display(recipesIngredients: recipe.ingredients.joined(separator: ", "))
        cell.display(time: recipe.time.timeFormmater)
        cell.display(rating: recipe.rate)
        cell.display(recipeImageUrl: recipeImageUrl)
    }
}
