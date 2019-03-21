//
//  SearchConfigurator.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 21/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

protocol SearchConfigurator {
    func configure(searchController: SearchController)
}

class SearchConfiguratorImplementation: SearchConfigurator {
    func configure(searchController: SearchController) {
        let presenter = SearchPresenterImplementation(view: searchController)
        searchController.presenter = presenter
    }
}
