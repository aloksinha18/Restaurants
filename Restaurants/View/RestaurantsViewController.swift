//
//  RestaurantsViewController.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-27.
//

import UIKit

final class RestaurantsViewController: UITableViewController {
    
    private let viewModel: RestaurantsListViewModel
    private let searchController = UISearchController()

    var didStartSearch:((String)-> Void)?
    var didCancelSearch:(()-> Void)?

    init(viewModel: RestaurantsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        tableView.register(RestaurantTableViewCell.self, forCellReuseIdentifier: "Cell")
        viewModel.onLoad = { [weak self] result in
            self?.tableView.reloadData()
        }
        viewModel.load()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantTableViewCell
        cell.configure(viewModel.filteredList[indexPath.row])
        return cell
    }
}


extension RestaurantsViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            return
        }
        didStartSearch?(text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        didCancelSearch?()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text , text.isEmpty else {
            return
        }
        didCancelSearch?()
    }
}
