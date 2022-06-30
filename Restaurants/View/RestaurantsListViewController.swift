//
//  RestaurantsViewController.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-27.
//

import UIKit

final class RestaurantsListViewController: UITableViewController {
    
    private let searchController = UISearchController()
    
    private var sortsOptionButton: UIButton = {
        let button = UIButton()
        button.setTitle(ButtonTitle.text, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = Layout.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let viewModel: RestaurantsListViewModel

    var didStartSearch:((String)-> Void)?
    var didCancelSearch:(()-> Void)?
    var didTapSortOptions:(()-> Void)?
    
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
        setupSearchController()
        registerTableView()
        bind()
        viewModel.load()
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
    
    private func bind() {
        viewModel.onLoad = loadTableView
        viewModel.onUpdate = loadTableView
    }
    
    func registerTableView() {
        tableView.register(RestaurantListTableViewCell.self, forCellReuseIdentifier: ReuseIdentifier.cell)

    }
    
    func loadTableView() {
        tableView.reloadData()
    }
    
    private func setupButton() {
        view.addSubview(sortsOptionButton)
        sortsOptionButton.widthAnchor.constraint(equalToConstant: Layout.width).isActive = true
        sortsOptionButton.heightAnchor.constraint(equalToConstant: Layout.height).isActive = true
        sortsOptionButton.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: Layout.trailing).isActive = true
        sortsOptionButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: Layout.bottom).isActive = true
        sortsOptionButton.addTarget(self, action: #selector(tapFilters), for: .touchUpInside)
    }
    
    @objc
    func tapFilters() {
        didTapSortOptions?()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.cell, for: indexPath) as! RestaurantListTableViewCell
        cell.configure(viewModel.filteredList[indexPath.row], sortOption: viewModel.selectedSortOption)
        return cell
    }
}


extension RestaurantsListViewController: UISearchResultsUpdating, UISearchBarDelegate {
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


private extension RestaurantsListViewController {
    
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
