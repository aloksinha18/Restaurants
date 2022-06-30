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
    private let sortsOptionButton = UIButton()

    var didStartSearch:((String)-> Void)?
    var didCancelSearch:(()-> Void)?
    var didTapFilter:(()-> Void)?
    
    init(viewModel: RestaurantsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        tableView.register(RestaurantTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        viewModel.onLoad = loadTableView
        viewModel.onUpdate = loadTableView
        viewModel.load()
    }
    
    func loadTableView() {
        tableView.reloadData()
    }
    
    private func setupButton() {
        sortsOptionButton.setTitle("Sort", for: .normal)
        sortsOptionButton.backgroundColor = .black
        sortsOptionButton.layer.cornerRadius = 25
        view.addSubview(sortsOptionButton)
        sortsOptionButton.translatesAutoresizingMaskIntoConstraints = false
        sortsOptionButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sortsOptionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sortsOptionButton.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: -16).isActive = true
        sortsOptionButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        sortsOptionButton.addTarget(self, action: #selector(tapFilters), for: .touchUpInside)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredList.count
    }
    
    @objc
    func tapFilters() {
        didTapFilter?()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantTableViewCell
        cell.configure(viewModel.filteredList[indexPath.row], sortOption: viewModel.sortOption)
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
