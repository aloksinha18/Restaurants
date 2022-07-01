//
//  LocalRestaurantsLoader.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-27.
//

import Foundation

class LocalRestaurantLoader: RestaurantLoader {
    
    enum Error: Swift.Error, LocalizedError {
        var errorDescription: String? {
            switch self {
            case .invalidData:
                return "Invalid data!"
            case .fileNotFound:
                return "File is not Found!"
            }
        }
        
        case invalidData
        case fileNotFound
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
                completion(self.parseResponse(data))
            case .failure:
                completion(.failure(Error.fileNotFound))
            }
        }
    }
    
    private func parseResponse(_ data: Data)  -> RestaurantLoader.Result {
        let decoder = JSONDecoder()
        
        do {
            let iems =  try decoder.decode(Root.self, from: data)
            return .success(iems.restaurants)
        } catch {
            return .failure(Error.invalidData)
        }
    }
}
