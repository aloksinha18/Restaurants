//
//  SortListViewController.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-28.
//

import UIKit

final class SortOptionsViewController: UITableViewController {
    
    let viewModel: SortOptionsViewModel
    
    var selectFilter:((FilterType)-> Void)?
    
    init(viewModel: SortOptionsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(RestaurantTableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return viewModel.filters.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewModel.filters[indexPath.row].description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectFilter?(viewModel.filters[indexPath.row])
    }
}
