//
//  SearchController.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 21/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import UIKit
import JGProgressHUD

class SearchController: UIViewController, SearchView {
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var ingredientsTableView: UITableView!
    private let loader = JGProgressHUD(style: .dark)

    var configurator = SearchConfiguratorImplementation()
    var presenter: SearchPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(searchController: self)

        setupTableView()
        ingredientsTextField.setBottomBorder()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }

    private func setupTableView() {
        ingredientsTableView.rowHeight = UITableView.automaticDimension
        ingredientsTableView.estimatedRowHeight = UITableView.automaticDimension
        ingredientsTableView.register(IngredientCell.self)
    }

    @IBAction func addButtonPressed() {
        presenter.addButtonPressed(ingredients: ingredientsTextField.text!)
        ingredientsTextField.text = ""
    }

    @IBAction func clearButtonPressed() {
        presenter.clearButtonPressed()
        ingredientsTextField.text = ""
    }

    @IBAction func searchRecipeButtonPressed() {
        presenter.searchRecipeButtonPressed()
    }

    func showLoader() {
        loader.show(in: self.view)
    }

    func hideLoader() {
        loader.dismiss()
    }

    func showError(title: String, message: String) {
        presentAlert(title: title, message: message)
    }

    func refreshRecipeSearchView() {
        ingredientsTableView.reloadData()
    }

    func refreshSearchView() {
        ingredientsTableView.reloadData()
    }
}

extension SearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfIngredients
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(IngredientCell.self)!
        presenter.configure(cell: cell, forRow: indexPath.row)
        return cell
    }
}

