//
//  SearchPresenter.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 21/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

protocol SearchView: class {
    func refreshSearchView()
    func showLoader()
    func hideLoader()
    func showError(title: String, message: String)
}

protocol IngredientCellView {
    func display(ingredient: String)
}

protocol SearchPresenter {
    var numberOfIngredients: Int { get }
    func configure(cell: IngredientCellView, forRow row: Int)
    func addButtonPressed(ingredients: String)
    func clearButtonPressed()
    func searchRecipeButtonPressed()
}

class SearchPresenterImplementation: SearchPresenter {
    weak var view: SearchView?

    init(view: SearchView) {
        self.view = view
    }

    var ingredients = [String]()
    var numberOfIngredients: Int {
        return ingredients.count
    }

    func clearButtonPressed() {
        ingredients = []
        view?.refreshSearchView()
    }

    func searchRecipeButtonPressed() {
        view?.showLoader()
        let ingredients = self.ingredients.map { $0 }.joined(separator: "+")
        let client = ApiClientImplementation()
        let url = URL(string: "https://api.yummly.com/v1/api/recipes?_app_id=82f4a536&_app_key=51bc109f3d02f621f3e62397cd754d62&q=\(ingredients)&requirePictures=true")!
        let request = ApiRecipesGatewayImplementation(url: url, client: client)
        request.fetchRecipes { [weak self] result in
            switch result {
            case let .success(recipes):
                if recipes.isEmpty {
                    self?.presentAlert(title: "Recipe not found !", message: "Try another please")
                } else {

                }
                self?.view?.hideLoader()
            case let .failure(error):
                self?.presentAlert(title: "Recipe not found !", message: error.localizedDescription)
                self?.view?.hideLoader()
            }
        }
    }

    fileprivate func presentAlert(title: String, message: String) {
        view?.showError(title: title, message: message)
        ingredients = []
        view?.refreshSearchView()
    }

    func addButtonPressed(ingredients: String) {
        let ingredients = ingredients
            .components(separatedBy: .punctuationCharacters)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { $0 != "" }
        ingredients.forEach { self.ingredients.append($0) }
        view?.refreshSearchView()
    }

    func configure(cell: IngredientCellView, forRow row: Int) {
        let ingredient = ingredients[row]
        cell.display(ingredient: ingredient)
    }
}
