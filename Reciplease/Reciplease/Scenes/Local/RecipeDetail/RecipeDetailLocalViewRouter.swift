//
//  RecipeDetailLocalViewRouter.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 22/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

protocol RecipeDetailLocalViewRouter {
    func dismiss()
}

class RecipeDetailLocalViewRouterImplementation: RecipeDetailLocalViewRouter {
    fileprivate weak var view: RecipeDetailLocalController?

    init(view: RecipeDetailLocalController) {
        self.view = view
    }

    func dismiss() {
        view?.navigationController?.popToRootViewController(animated: true)
    }
}
