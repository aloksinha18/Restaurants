//
//  RestaurantTableViewCell.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-28.
//

import UIKit

final class RestaurantListTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ restaurant: Restaurant, sortOption: SortingOptionType?) {
        self.textLabel?.text = restaurant.name
        guard let sortOption = sortOption else {
            self.detailTextLabel?.text = restaurant.status.rawValue.uppercased()
            return
        }
        self.detailTextLabel?.text = "\(restaurant.status.rawValue.uppercased()) ,  \(sortOption.description) : \(restaurant.value(sortOption))"
    }
}
