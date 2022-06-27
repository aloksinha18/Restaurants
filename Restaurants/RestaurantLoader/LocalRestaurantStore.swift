//
//  LocalRestaurantStore.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-27.
//

import Foundation

protocol RestaurantStore {
    func get(completion: @escaping (Result<Data, Error>)-> Void)
}

struct LocalRestaurantStore: RestaurantStore {
    
    static let name = "restaurants"
    
    func get(completion: @escaping (Result<Data, Error>)-> Void) {
        do {
            if let bundlePath = Bundle.main.path(forResource: LocalRestaurantStore.name,
                                                 ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                completion(.success(jsonData))
            }
        } catch (let error) {
            completion(.failure(error))
        }
    }
}
