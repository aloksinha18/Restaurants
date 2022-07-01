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
    
    func configure(viewModel: RestaurantListTableViewCellViewModel) {
        self.textLabel?.text = viewModel.title
        self.detailTextLabel?.text = viewModel.description
    }
}
