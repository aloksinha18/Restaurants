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
        let sortOptionsLoader = LocalStorage(loader: userDefaultStorage)
        let viewModel = RestaurantsListViewModel(loader: loader, sortOptionLoader: sortOptionsLoader)
        let controller = RestaurantsListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: controller)
        let sortingOptionsViewController = SortingOptionsListViewController(viewModel: SortingOptionsListViewModel())

        controller.didStartSearch = { searchedText in
            viewModel.sortedRestaurantsByNameAndNotify(searchedText)
        }
        
        controller.didCancelSearch = {
            viewModel.removeSearchAndNotify()
        }
        
        controller.didTapSortOptions = {
            navigationController.pushViewController(sortingOptionsViewController, animated: true)
        }
        
        sortingOptionsViewController.selectFilter = { sortOption in
            viewModel.sortedResultsBySortOption(sortOption)
            navigationController.popToRootViewController(animated: true)
        }
        
        return navigationController
    }
}
