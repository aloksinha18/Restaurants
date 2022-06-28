//
//  RestaurantTableViewCell.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-28.
//

import UIKit

final class RestaurantTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ restaurant: Restaurant) {
        self.textLabel?.text = restaurant.name
        self.detailTextLabel?.text = restaurant.status.rawValue
    }
}
