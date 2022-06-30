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
        
        tableView.register(RestaurantTableViewCell.self, forCellReuseIdentifier: ReuseIdentifier.cell)
        
        viewModel.onLoad = loadTableView
        viewModel.load()
    }
    
    func loadTableView() {
        tableView.reloadData()
    }
    
    private func setupButton() {
        sortsOptionButton.setTitle(ButtonTitle.text, for: .normal)
        sortsOptionButton.backgroundColor = .blue
        sortsOptionButton.layer.cornerRadius = Layout.cornerRadius
        view.addSubview(sortsOptionButton)
        sortsOptionButton.translatesAutoresizingMaskIntoConstraints = false
        sortsOptionButton.widthAnchor.constraint(equalToConstant: Layout.width).isActive = true
        sortsOptionButton.heightAnchor.constraint(equalToConstant: Layout.height).isActive = true
        sortsOptionButton.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: Layout.trailing).isActive = true
        sortsOptionButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: Layout.bottom).isActive = true
        sortsOptionButton.addTarget(self, action: #selector(tapFilters), for: .touchUpInside)
    }
    
    @objc
    func tapFilters() {
        didTapFilter?()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.cell, for: indexPath) as! RestaurantTableViewCell
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


private extension RestaurantsViewController {
    
    enum ReuseIdentifier {
        static let cell = "RestaurantTableViewCell"
    }
    
    enum ButtonTitle {
        static let text = "Sort"
    }
    
    enum Layout {
        static let height: CGFloat = 50.0
        static let width: CGFloat = 50.0
        static let trailing: CGFloat = -8
        static let bottom: CGFloat = -8
        static let cornerRadius: CGFloat = 25
    }
}
