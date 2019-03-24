//
//  RecipeDetailLocalController.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 22/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import UIKit
import SafariServices

class RecipeDetailLocalController: UIViewController, RecipeDetailView, SFSafariViewControllerDelegate {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var ratingImageView: [UIImageView]!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    var presenter: RecipeDetailLocalPresenterImplementation!
    var configurator: RecipeDetailLocalConfiguratorImplementation!

    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(recipeDetailView: self)
        presenter.viewDidLoad()
        
        setupTableView()
    }

    private func setupTableView() {
        ingredientsTableView.rowHeight = UITableView.automaticDimension
        ingredientsTableView.estimatedRowHeight = UITableView.automaticDimension
        ingredientsTableView.separatorStyle = .singleLine
        ingredientsTableView.tableFooterView = UIView()
        ingredientsTableView.register(IngredientCell.self)
        ingredientsTableView.register(NutritionCell.self)
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        presenter.favoritesButtonPressed()
    }

    @IBAction func getDirectionsPressed(_ sender: Any) {
        presenter.getDirectionsPressed()
    }

    func presentSafari(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }

    func displayRecipeDeleteError(title: String, message: String) {
        presentAlert(title: title, message: message)
    }

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    func favorite(recipe: Bool) {
        favoriteButton.image = #imageLiteral(resourceName: "green star").withRenderingMode(recipe ? .alwaysOriginal : .alwaysTemplate)
    }

    func display(recipeImageUrl: String) {
        backgroundImage.setImage(withUrl: recipeImageUrl)
    }

    func display(recipeName: String) {
        recipeNameLabel.text = recipeName
    }

    func display(rating: Int) {
        ratingImageView.forEach { if $0.tag <= rating { $0.image = #imageLiteral(resourceName: "yellow star") } }
    }

    func display(time: String) {
        timeLabel.text = time
    }
}

extension RecipeDetailLocalController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows.total
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < presenter.numberOfRows.ingredients {
            let cell = tableView.dequeueReusableCell(IngredientCell.self)!
            presenter.configure(cell: cell, forRow: indexPath.row)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(NutritionCell.self)!
            presenter.configure(cell: cell, forRow: indexPath.row)
            return cell
        }
    }
}
