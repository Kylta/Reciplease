//
//  RecipesListController.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 22/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import UIKit
import JGProgressHUD

class RecipesListController: UITableViewController, RecipesListView {
    private let loader = JGProgressHUD(style: .dark)
    var presenter: RecipesListPresenter!
    var configurator: RecipesListConfigurator!

    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(recipesListView: self)

        tableView.register(RecipesListCell.self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        presenter.router.dismiss()
    }

    func showLoader() {
        loader.show(in: self.view)
    }

    func hideLoader() {
        loader.dismiss()
    }

    func refreshView() {
        tableView.reloadData()
    }

    func displayRecipesRetrievalError(title: String, message: String) {
        presentAlert(title: title, message: message)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelect(row: indexPath.row)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numbersOfRecipes
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(RecipesListCell.self)!
        presenter.configure(cell: cell, forRow: indexPath.row)
        return cell
    }
}
