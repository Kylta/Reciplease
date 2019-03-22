//
//  RecipesListLocalConfigurator.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 22/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

class RecipesListLocalConfiguratorImplementation: RecipesListConfigurator {

    func configure(recipesListView: RecipesListView) {
        let recipesListLocalController = recipesListView as! RecipesListLocalController

        let viewContext = CoreDataStackImplementation.sharedInstance.persistentContainer.viewContext
        
        let coreDataRecipesGateway = CoreDataRecipesGateway(viewContext: viewContext)

        let displayRecipesUseCase = DisplayRecipesListUseCaseImplementation(recipeGateway: coreDataRecipesGateway)

        let router = RecipesListLocalRouterImplementation(recipesListLocalController: recipesListLocalController)
        let presenter = RecipesListLocalPresenterImplementation(view: recipesListLocalController, displayRecipesUseCase: displayRecipesUseCase, router: router)
        recipesListLocalController.presenter = presenter
        

    }
}
