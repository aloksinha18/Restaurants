//
//  Composer.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-30.
//

import Foundation
import UIKit

class Composer {
    static func rootViewController() -> UIViewController {
        let store = LocalRestaurantStore()
        let loader = LocalRestaurantLoader(store: store)
        let userDefaultStorage = UserDefaultStorage()
        let sortTypeManager = LocalStorage(localStoragePresentable: userDefaultStorage)
        let viewModel = RestaurantsListViewModel(restaurantLoader: loader, sortTypeManager: sortTypeManager)
        let controller = RestaurantsListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: controller)
        let sortTypesListViewController = SortTypesListViewController(viewModel: SortTypeListViewModel())
        
        controller.didTapSortType = {
            navigationController.pushViewController(sortTypesListViewController, animated: true)
        }
        
        sortTypesListViewController.selectSortType = { sortType in
            viewModel.sortRestaurantsBySortType(sortType)
            navigationController.popToRootViewController(animated: true)
        }
        
        return navigationController
    }
}
