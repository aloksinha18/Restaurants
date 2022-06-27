//
//  LocalRestaurantsLoader.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-27.
//

import Foundation

class LocalRestaurantLoader {
    
    enum Error: Swift.Error {
        case invalidData
    }
    
    private let store: RestaurantStore
    
    init(store: RestaurantStore) {
        self.store = store
    }
    
    func load(completion: @escaping (RestaurantLoader.Result) -> Void) {
        store.get { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let items = try self.parseResponse(data: data)
                    completion(items)
                } catch {
                    completion(.failure(error))
                }
            case .failure:
                completion(.failure(Error.invalidData))
            }
        }
    }
    
    private func parseResponse(data: Data) throws -> RestaurantLoader.Result {
        let decoder = JSONDecoder()
        
        do {
            let iems =  try decoder.decode(Root.self, from: data)
            return .success(iems.restaurants)
        } catch {
            throw LocalRestaurantLoader.Error.invalidData
        }
    }
}