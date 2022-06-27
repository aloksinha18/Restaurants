//
//  RestaurantLoader.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-27.
//

import Foundation

protocol RestaurantLoader {
    typealias Result = Swift.Result<[Restaurant] , Error>
    func load(completion: (RestaurantLoader.Result) -> Void)
}

