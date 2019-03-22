//
//  RecipesListController.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 22/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import UIKit

class RecipesListController: UITableViewController {
    var configurator: RecipesListConfigurator!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(RecipesListCell.self)
        tableView.dataSource = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(RecipesListCell.self)!
        return cell
    }
}
