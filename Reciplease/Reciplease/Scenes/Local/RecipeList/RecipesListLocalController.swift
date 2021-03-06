//
//  RecipesListLocalController.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 22/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import UIKit

class RecipesListLocalController: UITableViewController, RecipesListView {
    var presenter: RecipesListPresenter!
    var configurator = RecipesListLocalConfiguratorImplementation()

    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(recipesListView: self)
        presenter.viewDidLoad()
        tableView.register(RecipesListCell.self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }

    func refreshView() {
        tableView.reloadData()
    }

    func displayRecipesRetrievalError(title: String, message: String) {
        presentAlert(title: title, message: message)
    }

    func showLoader() {}

    func hideLoader() {}
}

extension RecipesListLocalController {
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
