//
//  RestaurantsViewController.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-27.
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

final class RestaurantsViewController: UITableViewController {
    
    private let viewModel: RestaurantsListViewModel
    
    init(viewModel: RestaurantsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(RestaurantTableViewCell.self, forCellReuseIdentifier: "Cell")
        viewModel.onLoad = { [weak self] result in
            self?.tableView.reloadData()
        }
        viewModel.load()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantTableViewCell
        cell.configure(viewModel.restaurants[indexPath.row])
        return cell
    }
}
