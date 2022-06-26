//
//  RestaurantLoader.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-27.
//

import Foundation

protocol RestaurantLoader {
    func load(completion: Result<[Restaurant] , Error>)
}
